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

func TestRenderOsduAirflow2Deployments(t *testing.T) {
	t.Parallel()
	deploymentTemplates := []string{
		"charts/airflow/templates/db-migrations/db-migrations-deployment.yaml",
		"charts/airflow/templates/scheduler/scheduler-deployment.yaml",
		"charts/airflow/templates/webserver/webserver-deployment.yaml",
	}

	// To test if the msosdu it is present in the above files by default
	for _, dt := range deploymentTemplates {
		t.Run(fmt.Sprintf("Default_msosdu_%s", filepath.Base(dt)), func(t *testing.T) {
			// arrange
			chartPath, err := filepath.Abs(chartRelPath)
			releaseName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
			namespace := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

			require.NoError(t, err)

			options := &helm.Options{
				KubectlOptions: k8s.NewKubectlOptions("", "", namespace),
			}

			// act
			t.Log(fmt.Sprintf("Helm chart path: %s", chartPath))

			output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{dt}, "--kube-version", kubeVersion)

			var deployment appsv1.Deployment
			helm.UnmarshalK8SYaml(t, output, &deployment)

			// assert
			deploymentSetContainers := deployment.Spec.Template.Spec.Containers
			require.Equal(t, len(deploymentSetContainers), 1)
			assert.Contains(t, deploymentSetContainers[0].Image, "msosdu.azurecr.io")
		})
	}
}
