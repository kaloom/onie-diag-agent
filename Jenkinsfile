#!/usr/bin/groovy
@Library("kaloom") _

runPipeline {
    default_recipient = "frch@kaloom.com"

    stages {
        def builds = ["Build", "Publish"]

        builder.init this

        gitlabBuilds(builds: builds) {
            kaloomStage("Build") {
                buildInfo = builder.run timeout: 30, "build artifactoryPublish -si"
            }
            kaloomStage("Publish", when: kaloomUtil.shouldPublish()) {
                builder.promote("internal-releases")
            }
        }
    }
}
