from airflow.plugins_manager import AirflowPlugin
from airflow.utils.session import provide_session
from airflow.security import permissions
from airflow.api_connexion import security
from airflow.models.dagrun import DagRun
from airflow.utils.state import State
from flask import Blueprint

# Creating a flask blueprint to integrate the templates and static folder
dag_runs_stats_bp = Blueprint("dag_run_stats_plugin", __name__, url_prefix="/activeDagRuns")

@dag_runs_stats_bp.route("/", methods = ['GET'])
@security.requires_access(
    [
        (permissions.ACTION_CAN_READ, permissions.RESOURCE_DAG),
        (permissions.ACTION_CAN_READ, permissions.RESOURCE_DAG_RUN)
    ]
)

@provide_session
def send_active_dag_runs_count(session):
    running_dag_run_count = session.query(DagRun).filter(DagRun.state==State.RUNNING).count()
    return {"active_dag_runs": running_dag_run_count}

# Defining the plugin class
class AirflowDagRunsStatsPlugin(AirflowPlugin):
    name = "dag_runs_stats_plugin"
    flask_blueprints = [dag_runs_stats_bp]