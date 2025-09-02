plugins {
    // Core plugins (declare here, apply false so they’re only used in modules)
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false

    // Google Services plugin for Firebase
    id("com.google.gms.google-services") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Custom build directory setup (kept from your file)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}




//buildscript {
//    repositories {
//        google()
//        mavenCentral()
//    }
//    dependencies {
//        classpath("com.google.gms:google-services:4.4.2") // 👈 Add this
//    }
//}
//
//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//        gradlePluginPortal()
//    }
//}
//
//val newBuildDir: Directory =
//    rootProject.layout.buildDirectory
//        .dir("../../build")
//        .get()
//rootProject.layout.buildDirectory.value(newBuildDir)
//
//subprojects {
//    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//    project.layout.buildDirectory.value(newSubprojectBuildDir)
//}
//subprojects {
//    project.evaluationDependsOn(":app")
//}
//
//tasks.register<Delete>("clean") {
//    delete(rootProject.layout.buildDirectory)
//}
