import com.jetbrains.qodana.api.client.apis.QodanaCloudPublicApi
import com.jetbrains.qodana.api.client.models.ProjectTokenRequest
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val qodanaCloudBasePath = "https://qodana.cloud"
    val qodanaOrganizationToken = "YOUR_TOKEN_HERE"

    val api = QodanaCloudPublicApi(
        basePath = qodanaCloudBasePath,
        client = getApiClient(qodanaOrganizationToken))

    val request = ProjectTokenRequest(
        teamName = "my-team",
        projectName = "my-project"
    )

    val response = api.getProjectToken(request)

    println("Project token: ${response.projectToken}")
}

private fun getApiClient(token: String): OkHttpClient {
    return OkHttpClient.Builder()
        .addInterceptor(Interceptor { chain ->
            val original: Request = chain.request()
            val requestWithAuth = original.newBuilder()
                .header("Authorization", "Bearer $token")
                .build()
            chain.proceed(requestWithAuth)
        })
        .build()
}
