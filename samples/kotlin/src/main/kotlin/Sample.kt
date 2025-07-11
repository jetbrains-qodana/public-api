import com.jetbrains.qodana.api.client.apis.QodanaCloudPublicApi
import com.jetbrains.qodana.api.client.models.ProjectTokenRequest

fun main() {
    val api = QodanaCloudPublicApi("https://cloud")

    val request = ProjectTokenRequest(
        teamName = "my-team",
        projectName = "my-project"
    )

    // todo add 'Authorization'
    val response = api.getProjectToken(request)

    println("Project token: ${response.projectToken}")
}
