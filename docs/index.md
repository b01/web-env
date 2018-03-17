## How to Use

1. Clone this repository and change into the directory.
2. To test, open a bash terminal and run:
   `docker-compose --project-name=compose_client_platforms up --remove-orphans`
3. Verify that the environment is working on your PC by going to 
   "https://127.0.0.1/" in a web browser.
4. Now shut down the docker web environment (you'll bring it back up in a sec):
   `docker-compose --project-name=compose_client_platforms down`
5. Now bring the environment back up in the background.
    