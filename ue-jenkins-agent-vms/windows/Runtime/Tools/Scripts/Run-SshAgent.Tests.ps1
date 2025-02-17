. ${PSScriptRoot}\Ensure-TestToolVersions.ps1

BeforeAll {

	. ${PSScriptRoot}\Run-DockerAgent.ps1
	. ${PSScriptRoot}\Run-SshAgent.ps1

}

Describe 'Run-SshAgent' {

	It "Throws an exception if Run-DockerAgent fails" {

		Mock Run-Dockeragent -ParameterFilter { ($AgentImageUrl -eq "agent-image") -and ($AgentRunArguments[0] -eq "--rm") } { throw "Run-DockerAgent failed" }
		Mock Run-DockerAgent { throw "Invalid invocation of Run-DockerAgent" }

		{ Run-SshAgent -AgentJarFolder "C:\AgentJar" -AgentJarFile "C:\AgentJar\agent.jar" -JenkinsAgentFolder "C:\JenkinsAgent" -JenkinsWorkspaceFolder "C:\JenkinsWorkspace" -PlasticConfigFolder "C:\PlasticConfig" -AgentImageURL "agent-image" } |
			Should -Throw

		Assert-MockCalled -Times 1 -Exactly Run-Dockeragent -ParameterFilter { ($AgentImageUrl -eq "agent-image") -and ($AgentRunArguments[0] -eq "--rm") }
		Assert-MockCalled -Times 1 -Exactly Run-DockerAgent
	}

	It "Succeeds if Run-DockerAgent succeeds" {

		Mock Run-Dockeragent -ParameterFilter { ($AgentImageUrl -eq "agent-image") -and ($AgentRunArguments[0] -eq "--rm") } { }
		Mock Run-DockerAgent { throw "Invalid invocation of Run-DockerAgent" }

		{ Run-SshAgent -AgentJarFolder "C:\AgentJar" -AgentJarFile "C:\AgentJar\agent.jar" -JenkinsAgentFolder "C:\JenkinsAgent" -JenkinsWorkspaceFolder "C:\JenkinsWorkspace" -PlasticConfigFolder "C:\PlasticConfig" -AgentImageURL "agent-image" } |
			Should -Not -Throw

		Assert-MockCalled -Times 1 -Exactly Run-Dockeragent -ParameterFilter { ($AgentImageUrl -eq "agent-image") -and ($AgentRunArguments[0] -eq "--rm") }
		Assert-MockCalled -Times 1 -Exactly Run-DockerAgent
	}
}