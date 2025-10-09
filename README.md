# Qodana public API

[![official JetBrains project](https://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

Qodana Cloud and Qodana Self-Hosted provide the public REST API that lets you use build pipelines for:

* Creating teams and projects
* Getting a list of users for a specific organization

## Contents
This repository contains
* `openapi.yaml` - OpenAPI specification of the REST API. This file updates when new changes in the API are implemented.
* `samples/kotlin` - Sample client in Kotlin based on code generation over `openapi.yaml`.

## How to use the API
Steps are described at https://www.jetbrains.com/help/qodana/cloud-api.html

## License

This repository is licensed under the Apache-2.0 License.

## Prerequisites

The public API requires an organization API token for authentication purposes.

Before using the public API, make sure that the following requirements were met:

1. To create and manage an organization API token, you should have access to an existing Qodana Cloud [organization](https://www.jetbrains.com/help/qodana/cloud-organizations.html#cloud-organizations-create-organization) under the `Owner` or `Admin` [role](https://www.jetbrains.com/help/qodana/cloud-user-roles.html#cloud-user-org-roles-owner). 
2. Your Qodana Cloud organization is licensed under the Ultimate Plus [license](https://www.jetbrains.com/help/qodana/pricing.html).
3. To generate an organization API token, navigate to your [organization settings](https://www.jetbrains.com/help/qodana/cloud-organization.html#cloud-organizations-api-token).

For all examples provided in this section, replace the `{qodana_cloud_url}` placeholder with your 
base URL, i.e. with `qodana.cloud` for Qodana Cloud, or using your custom base URL in case of Qodana Self-Hosted.

An organization API token value is referred to as `$permanent_organization_token`.

## Create teams and projects

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

Below is the explanation of responses.

### 200

Returns a project token for an existing project within an existing team:

```http
HTTP/2 200 OK
date: Wed, 24 Sep 2025 10:35:13 GMT
content-type: application/json
x-request-id: vbf3up0ktfm6b25o
vary: Origin
content-length: 178
x-http2-stream-id: 3

  {
    "projectToken": "{TheProjectTokenValue}"
  }
```

### 201

Creates a new team (if applicable) and a new project within the team, generates and returns a project token for a newly created project:

```http
HTTP/2 201 Created
date: Wed, 24 Sep 2025 10:33:37 GMT
content-type: application/json
x-request-id: nrkvy1od9m3ohb9u
vary: Origin
content-length: 178
x-http2-stream-id: 3

  {
    "projectToken": "{TheProjectTokenValue}"
  }    
```

### 400

Bad request response returns if the public API is disabled for a specific environment:

```http
HTTP/2 400 Bad Request
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89ztzxra5ptt3vio
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "public_api_disabled",
    "details": "Public API is disabled"
  }
```        

This returns if the number of projects in the Qodana Cloud organization exceeds 5000:

```http
HTTP/2 400 Bad Request
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89ztzxra5ptt3vio
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "too_many_projects_for_organization",
    "details": "Creation of the project failed because of reaching the limit of projects per organization"
  }
```

### 401

Unauthorized access occurs if an API token was not provided:

```http
HTTP/2 401 Unauthorized
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "no_auth",
    "details": "User is not authorized"
  }
```

### 403

The access forbidden response returns in case the API token is no longer valid:

```http
HTTP/2 403 Forbidden
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "no_permission",
    "details": "Invalid organization API token"
  }
```

This returns in case a Qodana Cloud organization cannot use the public API feature:

```http
HTTP/2 403 Forbidden
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "no_permission",
    "details": "User has no public_api_create_or_get_project_token permission"
  }
```

### 404

Endpoint not found. 

### 500

The internal server error returns if a project token could not be created:

```http
HTTP/2 500 Internal Server Error
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "project_token_creation_failed",
    "details": "Creation of the project token failed because of an internal error"
  }
```
        
## Get a list of organization users

To get a list of users of a specific [Qodana Cloud organization](https://www.jetbrains.com/help/qodana/cloud-organizations.html) in a paginated form, send a `GET` request using the
`https://{qodana_cloud_url}/api/v1/public/organizations/users` endpoint, for example: 

```cURL
curl -X GET \
   "https://{qodana_cloud_url}/api/v1/public/organizations/users" \
   -H "Authorization: Bearer $permanent_organization_token"
```

### Parameters

You can customize your requests using the following optional parameters.

|Parameter|Type|Description|
|---------|----|-----------|
|`limit` | Integer | Limit the number of users in the returned list |
|`offset` | Number | Set the offset for the returned list to `N`. For example, `1` means that the list will start from the second user |
|`order` | String | Sort the order. Accepts `DESC` for descending order or `ASC` for ascending order. By default, lists are sorted in ascending order |
|`search` | String | Return a list of entries that contain a specified substring in the `email` or `displayName` fields |

For example, this request returns ten user entries starting from the second entry only if those contain `abc`
in the `email` or `displayName` fields and sorts the selected list in descending order:

```cURL
curl -X GET \
   "https://{qodana_cloud_url}/api/v1/public/organizations/users?limit=10&offset=1&order=DESC&search=abc" \
   -H "Authorization: Bearer $permanent_organization_token"
```

### Responses

The `https://{qodana_cloud_url}/api/v1/public/organizations/users` endpoint responds as described in the table:

#### 200

Returns a list of organization users for a specified Qodana Cloud organization:

```http
HTTP/2 200 OK
date: Wed, 24 Sep 2025 10:39:06 GMT
content-type: application/json
x-request-id: 7vrrlorq2ocrz957
vary: Origin
content-length: 514
x-http2-stream-id: 3
           
{
  "count": 3, // The number of entries retrieved
  "next": 3,  // The `offset` value to fetch the next chunk of entries
  "prev": 0, // The offset from the first entry
  "items": [
             {
               "id": "GoKgG",
               "email": "email-address1@example.com",
               "displayName": "email-address1@example.com",
               "role": "OWNER", // Qodana Cloud role
               "isActive": true,
               "isSsoManaged": false, // SSO feature is disabled
               "invitationId": "G4O3Y" //
             },
             {
               "id": "bvWmV",
               "email": "email-address2@example.com",
               "displayName": "email-address2@example.com",
               "role": "VIEWER",
               "isActive": false,
               "isSsoManaged": false
             },
             {
               "id": "NG4kY",
               "email": "email-address3@example.com",
               "displayName": "email-address3@example.com",
               "role": "VIEWER",
               "isActive": false,
               "isSsoManaged": false,
               "invitationId": "bLmWV"
             }
           ]
}
```

#### 400

The public API is disabled:

```http
HTTP/2 400 Bad Request
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89ztzxra5ptt3vio
vary: Origin
content-length: 67
x-http2-stream-id: 3

{
  "name": "public_api_disabled",
  "details": "Public API is disabled"
}
```

#### 401

Unauthorized access occurs if an API token was not provided:

```http
HTTP/2 401 Unauthorized
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "no_auth",
    "details": "User is not authorized"
  }
```
        
#### 403

This returns in case an API token is no longer valid:

```http
HTTP/2 403 Forbidden
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "no_permission",
    "details": "Invalid organization API token"
  }
```

This returns in case a Qodana Cloud organization cannot use the public API feature:

```http
HTTP/2 403 Forbidden
date: Wed, 24 Sep 2025 10:36:37 GMT
content-type: application/json
x-request-id: 89zthxrm5pxt9phi
vary: Origin
content-length: 67
x-http2-stream-id: 3

  {
    "name": "no_permission",
    "details": "User has no public_api_get_organization_users permission"
  }
```

#### 404

Endpoint not found.
