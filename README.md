1. Build the image from the Dockerfile provided with 
`docker build -t iris-dirac .` 
or pull from dockerhub
`docker pull rohinijoshi/iris-dirac:latest`
2. The centos-home directory serve as your user's home directory inside the container, we will mount this directory when running the container
3. Copy your grid certificate (.p12 file) into the centos-home directory named as cert.p12
4. Run container as root with a name so we can commit it after our changes are made

   Here my local directory is /Users/r.joshi/Projects/docker/iris-test-case/centos-home/
`docker run --tty --interactive --volume /Users/r.joshi/Projects/docker/iris-test-case/centos-home/:/home/user --workdir /home/user --name complete_dirac_install iris-dirac /bin/bash`
5. Run setup script once inside the container (will require grid certificate password multiple times)
`./setup-grid-tools`
6. In a separate terminal, from outside the container, commit the changes made by the setup script by running
`./commit-me`
7. Exit out of the container, and shell back in as a regular user to submit a test payload
`docker run --user user --tty --interactive --volume /Users/r.joshi/Projects/docker/iris-test-case/centos-home/:/home/user --workdir /home/user iris-dirac:dirac /bin/bash`
8. Run the following alias to set your grid proxy (short-lived x509 proxy) for auth
`setup-grid-proxy`
9. Execute the job-submit script 
`cd centos-home/test-payload/`

`./job-submit.py ` 
