//subprojects {
//    println("project: ${project.name}")
//    project.gradle.afterProject {
//        val android = project.properties["android"] as BaseExtension
//        if (android != null && android.namespace == null) {
//            println(" ${project.name} namespace is null chane to ${project.group}")
//            android.namespace = project.group.toString()
//        }
//    }
//}

buildscript {
    repositories {
        maven(url = "https://maven.aliyun.com/repository/public/")
        maven(url = "https://maven.aliyun.com/repository/spring/")
        maven(url = "https://maven.aliyun.com/repository/google/")
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        maven(url = "https://maven.aliyun.com/repository/public/")
        maven(url = "https://maven.aliyun.com/repository/spring/")
        maven(url = "https://maven.aliyun.com/repository/google/")
        google()
        mavenCentral()
    }
}




val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
