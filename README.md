NOT PRODUCTION READY DUE TO PLAINTEXT USER DEFINITION IN configuration.nix

Quickstart (Linux):

0. Install nix. See https://nix.dev/install-nix.html
1. Clone this repo: `git clone https://github.com/totalCloud-Nickverse/github_boilerplate`
2. Move into the cloned directory: `cd github_boilerplate`
3. Make the buildCommand file executable: `chmod +x ./buildCommand`
4. Run the buildCommand: ./buildCommand
5. Start the VM with ./result/bin/run-testHostname-vm
6. On the host machine, go to localhost:9999 in your browser to see the hello world page displayed by gunicorn.


To view grafana dashboard in the running vm:
0. Get to step 5 above
1. On the host machine, go to localhost:12345

To build an AMI with matching configuration:

nix build .#ami


