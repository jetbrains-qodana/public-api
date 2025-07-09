plugins {
    kotlin("jvm") version "2.2.0"
    id("org.openapi.generator") version "7.14.0"
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.google.code.gson:gson:2.10.1")

    testImplementation(kotlin("test"))
}

openApiGenerate {
    generatorName.set("kotlin")
    inputSpec.set("$rootDir/../../openapi.yaml")
    outputDir.set(layout.buildDirectory.dir("generated").get().asFile.path)
    packageName.set("com.jetbrains.qodana.api.client")
    additionalProperties.set(
        mapOf(
            "library" to "jvm-okhttp4",
            "serializationLibrary" to "gson",
            "apiName" to "QodanaCloudPublic"
        )
    )
}

tasks.withType<org.openapitools.generator.gradle.plugin.tasks.GenerateTask> {
    outputs.upToDateWhen { false }
}

tasks.named("openApiGenerate") {
    doFirst {
        delete(layout.buildDirectory.dir("generated"))
    }

    doLast {
        val generatedDir = layout.buildDirectory.dir("generated/src/main/kotlin").get().asFile
        val oldName = "PublicAPIApi"
        val newName = "QodanaCloudPublicApi"

        val oldFile = generatedDir.walkTopDown().firstOrNull {
            it.name == "$oldName.kt"
        }

        if (oldFile != null) {
            val newFile = File(oldFile.parentFile, "$newName.kt")

            oldFile.renameTo(newFile)

            val updatedContent = newFile.readText().replace("class $oldName", "class $newName")
            newFile.writeText(updatedContent)

            println("✅ Renamed $oldName to $newName")
        } else {
            println("⚠️ Could not find $oldName.kt")
        }
    }
}

sourceSets["main"].java.srcDir(layout.buildDirectory.dir("generated/src/main/kotlin"))

tasks.test {
    useJUnitPlatform()
}
