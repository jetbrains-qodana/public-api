# Qodana public API [![official JetBrains project](https://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

Qodana Cloud and Qodana Self-Hosted provide the public REST API that lets you use build pipelines for:

* Creating teams and projects
* Getting a list of users for a specific organization

## Contents
This repository contains
* `openapi.yaml` - OpenAPI specification of the REST API. This file updates when new changes in the API are implemented.
* `samples/kotlin` - Sample client in Kotlin based on code generation over `openapi.yaml`.

## Documentation
Comprehensive information about Qodana Public API is available in the [official documentation](https://www.jetbrains.com/help/qodana/cloud-api.html).

A brief summary and examples are provided below for convenience.

## Quick reference
### Prerequisites

The public API requires an organization API token for authentication purposes.

Before using the public API, make sure that the following requirements were met:

1. To create and manage an organization API token, you should have access to an existing Qodana Cloud [organization](https://www.jetbrains.com/help/qodana/cloud-organizations.html#cloud-organizations-create-organization) under the `Owner` or `Admin` [role](https://www.jetbrains.com/help/qodana/cloud-user-roles.html#cloud-user-org-roles-owner). 
2. Your Qodana Cloud organization is licensed under the Ultimate Plus [license](https://www.jetbrains.com/help/qodana/pricing.html).
3. To generate an organization API token, navigate to your [organization settings](https://www.jetbrains.com/help/qodana/cloud-organization.html#cloud-organizations-api-token).

For all examples provided in this section, replace the `{qodana_cloud_url}` placeholder with your 
base URL, i.e. with `qodana.cloud` for Qodana Cloud, or using your custom base URL in case of Qodana Self-Hosted.

An organization API token value is referred to as `$permanent_organization_token`.

### Create teams and projects

To create a new team (if applicable) along with a project and obtain a [project token](https://www.jetbrains.com/help/qodana/project-token.html), send a `POST` request to the 
`https://{qodana_cloud_url}/api/v1/public/organizations/projects` endpoint and provide the team and project names, for example: 

```cURL
qodana_token=$(curl -X POST https://{qodana_cloud_url}/api/v1/public/organizations/projects \
  -H "Authorization: Bearer $permanent_organization_token" \
  -d '{
        "projectName": "My project name",
        "teamName": "My team name"
      }')
```

The `teamName` parameter provides a string non-nullable name of the team that you would like to
create. In case a team with such name already exists, creation of a new team will be skipped.
Under the `projectName` parameter, provide a string non-nullable name of the project that you would like to create. In
case a project with such name already exists, creation of a new project will be skipped.

Below is the brief explanation of HTTP responses of the endpoint:
* HTTP 200 - Returns a project token for an existing project within an existing team
* HTTP 201 - Creates a new team (if applicable) and a new project within the team, generates and returns a project token for a newly created project:
* HTTP 400 - Bad request
* HTTP 401 - Unauthorized access occurs if an API token was not provided
* HTTP 403 - The access forbidden
* HTTP 404 - Endpoint not found 
* HTTP 500 - The internal server error returns if a project token could not be created

Refer to the full documentation for complete details and sample responses.
        
### Get a list of organization users

To get a list of users of a specific [Qodana Cloud organization](https://www.jetbrains.com/help/qodana/cloud-organizations.html) in a paginated form, send a `GET` request using the
`https://{qodana_cloud_url}/api/v1/public/organizations/users` endpoint, for example: 

```cURL
curl -X GET \
   "https://{qodana_cloud_url}/api/v1/public/organizations/users" \
   -H "Authorization: Bearer $permanent_organization_token"
```

#### Parameters

You can customize your requests using the following optional parameters.

|Parameter|Type|Description|
|---------|----|-----------|
|`limit` | Integer | Limit the number of users in the returned list |
|`offset` | Number | Set the offset for the returned list to `N`. For example, `1` means that the list will start from the second user |
|`order` | String | Sort the order. Accepts `DESC` for descending order or `ASC` for ascending order. By default, lists are sorted in ascending order |
|`search` | String | Return a list of entries that contain a specified substring in the `email` or `displayName` fields |

For example, this request returns ten user entries starting from the second entry only if those contain `abc`
in the `email` or `displayName` fields and sorts the selected list in descending order:

#### Responses

Below is the brief explanation of HTTP responses of the endpoint:
* HTTP 200 - Returns a list of organization users for a specified Qodana Cloud organization
* HTTP 400 - The public API is disabled
* HTTP 401 - Unauthorized access occurs if an API token was not provided
* HTTP 401 - Unauthorized access occurs if an API token was not provided
* HTTP 403 - The access forbidden
* HTTP 404 - Endpoint not found
* HTTP 500 - The internal server error returns if a project token could not be created

Refer to the full documentation for complete details and sample responses.

## License

This repository is licensed under the Apache-2.0 License.
