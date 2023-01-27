package test

// https://www.phillipsj.net/posts/yes-you-can-unit-test-helm-charts/
import (
	"fmt"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	appsv1 "k8s.io/api/apps/v1"
)

const chartRelPath = "../../../osdu-airflow2"
const kubeVersion = "1.24"

func TestHelmOsduAirflow2(t *testing.T) {
	t.Parallel()
	deploymentTemplates := []string{
		"charts/airflow/templates/db-migrations/db-migrations-deployment.yaml",
		"charts/airflow/templates/scheduler/scheduler-deployment.yaml",
		"charts/airflow/templates/webserver/webserver-deployment.yaml",
	}

	shouldNotContainCases := []struct {
		name string
		path string
	}{
		{
			"NoPostgresChart",
			"charts/airflow/charts/postgresql/templates/statefulset.yaml",
		},
		{
			"NoRedisChart",
			"charts/airflow/charts/redis/templates/redis-master-statefulset.yaml",
		},
	}

	chartPath, err := filepath.Abs(chartRelPath)
	releaseName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	require.NoError(t, err)

	namespace := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
	t.Log(fmt.Sprintf("Namespace: %s", namespace))
	t.Log(fmt.Sprintf("Helm chart path: %s", chartPath))

	options := &helm.Options{
		KubectlOptions: k8s.NewKubectlOptions("", "", namespace),
	}

	// To test if the msosdu it is present in the above files by default
	for _, dt := range deploymentTemplates {
		t.Run(fmt.Sprintf("Default_msosdu_%s", filepath.Base(dt)), func(t *testing.T) {

			output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{dt}, "--kube-version", kubeVersion)

			var deployment appsv1.Deployment
			helm.UnmarshalK8SYaml(t, output, &deployment)

			// assert
			deploymentSetContainers := deployment.Spec.Template.Spec.Containers
			require.Equal(t, len(deploymentSetContainers), 1)
			assert.Contains(t, deploymentSetContainers[0].Image, "msosdu.azurecr.io")
		})
	}

	// To test that the postgres and redis are not present
	for _, testCase := range shouldNotContainCases {
		testCase := testCase
		t.Run(testCase.name, func(t *testing.T) {
			_, err := helm.RenderTemplateE(t, options, chartPath, releaseName, []string{testCase.path}, "--kube-version", kubeVersion)
			// Assert that does not contains these templates
			require.Error(t, err)
		})
	}

	// To test Total Output
	t.Run("FullHelmRender", func(t *testing.T) {
		_, err := helm.RenderTemplateE(t, options, chartPath, releaseName, []string{}, "--kube-version", kubeVersion)
		require.NoError(t, err)
	})
}
