allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    layout.buildDirectory.value(newBuildDir.dir(project.name))
    evaluationDependsOn(":app")
    
    // Aplicar versión NDK a todos los proyectos Android
    plugins.withId("com.android.application") {
        configure<com.android.build.gradle.BaseExtension> {
            ndkVersion = "27.0.12077973"
        }
    }
    
    plugins.withId("com.android.library") {
        configure<com.android.build.gradle.BaseExtension> {
            ndkVersion = "27.0.12077973"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//     }
// }
// 
// val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
// rootProject.layout.buildDirectory.value(newBuildDir)
// 
// subprojects {
//    layout.buildDirectory.value(newBuildDir.dir(project.name))
//    evaluationDependsOn(":app")
//    
//    plugins.withId("com.android.application") {
//        configure<com.android.build.gradle.BaseExtension> {
//            ndkVersion = "27.0.12077973"
//        }
//    }
// }
// 
// subprojects {
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)
// }
// subprojects {
//     project.evaluationDependsOn(":app")
// }
// 
// tasks.register<Delete>("clean") {
//     delete(rootProject.layout.buildDirectory)
// }
// 