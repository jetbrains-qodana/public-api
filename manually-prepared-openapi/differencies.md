### Nice to have
 * [method] 'summary' vs 'description' fields for method, the plugin generates 'description' which is supposed some detailed info 
   while 'summary' should provide brief purpose of the method
 * [method] 'operationId' - this could be useful to have for code generation purposes
 * [method parameter] 'description' is missing
 * [method parameter] 'enum' is missing
 * [method response] 'example' section?
 * [component schema] no 'description'? (you may specify 'description' next to 'response' although, that is kind of fine
   while we have very few methods here and openapi is easily readable)
 * [component schema] no 'description' for each property
 * [workaround possible] 'security' section is missing, however this could be added on script postprocessing
 * [workaround possible] 'info' section - it fills some predefined values, it is not clear how to specify something 
   there, however this could be postprocessed in the script
 * [workaround possible] 'servers' - the same like 'info' section
