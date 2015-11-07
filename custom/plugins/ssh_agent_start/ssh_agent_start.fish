# Adapted from https://gist.github.com/rsff/9366074

#this script can never fail
#i use it in the fish_config
#call it with ssh_agent_start

# Create ~/.ssh if it doesn't exist
if [ ! -d "$HOME/.ssh" ]
	mkdir -p $HOME/.ssh
end
# SSH environment file to read env variables from when ssh-agent is already running
setenv SSH_ENV $HOME/.ssh/environment

# this starts the agent or reads env vars if agent is already started
function ssh_agent_start
	# Check if SSH_AGENT_PID is set
	if [ -n "$SSH_AGENT_PID" ]
		# If so, then check if ssh-agent is actually running with this pid
		ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
		if [ $status -eq 0 ]
			test_identities
		end
	else
		# SSH_AGENT_PID is not set...
		# If ssh env file exists, source it
		if [ -f $SSH_ENV ]
			. $SSH_ENV > /dev/null
		end
		# FIXME Check if ssh-agent is running, will fail when SSH_AGENT_PID is not set
		# 	since grep will give an error, but if SSH_AGENT_PID="" then will
		# 	succeed, which is iffy.
		ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
		if [ $status -eq 0 ]
			test_identities
		else
			echo "Initializing new SSH agent ..."
	        	ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
			echo "Success."
			chmod 600 $SSH_ENV
			. $SSH_ENV > /dev/null
			ssh-add
		end
	end
end


function test_identities
	ssh-add -l | grep "The agent has no identities" > /dev/null
	if [ $status -eq 0 ]
		ssh-add
		if [ $status -eq 2 ]
			# FIXME: This is iffy, if there is problems with the code, may lead to recursive calls
			ssh_agent_start
		end
	end
end


#function fish_title
#	if [ $_ = 'fish' ]
#		echo (prompt_pwd)
#	else
#		echo $_
#	end
#end
