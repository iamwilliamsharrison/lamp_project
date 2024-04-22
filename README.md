# lamp_project
              Alt-school exam Project (Deploying a LAMP Stack using Bash Script and Ansible)
 

  In Accomplishing this Project 
I started by provisioning my Vagrant machine (master & slave)  I gave my Master an ip: 192.168.33.10  and my slave ip: 192.168.33.11

![Vagrantfile](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/c635430f-f512-4388-b6d2-9a3a4daf3fbe)


 I created a bash script file named lamp_deploy.sh gave it an executable command using chmod +x lamp_deploy.sh with sets of instruction contained in file (File is attached to the Project)
 
 ![BashScript](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/782a2860-2c97-434c-b4e3-e8509305eaa7)


Initially i struggled with composer,php8.2, postgresql, and .env installation and configuration module in my bash script i finally discarded postgresql and used mysql and the sed command to effect changes in my .env file and my application worked.
![MasterApplication](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/03065f1a-dab7-4c7b-871f-a3d8bf0ebc16)


          For My Ansible 
I installed Ansible and python3 on my master machine

To link my master machine and slave using ssh, i created public keys using my ssh-keygen command in my master & slave machine

![ssh-keygen](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/e8f020fd-1839-4218-bcc4-b2a8268e85f7)


I went into the ~/.ssh directory to get my public keys from both my master and slave machines. I then attached my master public key to my slave authorized keys and vice-versa for my slave

![Public AuthorizedKeys](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/7a67205d-3db1-4138-b8db-f37efbc79a44)


I went into the /etc/sshd_config for both machines to edit my config and restarted my sshd after that
![sshd__config](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/83dbe029-004a-4874-b6ec-47673d97dce0) 
After this i could ssh into my slave from my master using it's ip address (ssh vagrant@192.168.33.11 && ssh vagrant@192.168.33.10 for my master)


I wrote my ansible playbook (playbook.yml attached);
      i. To be able to ping my slave 
      ii. copy and execute my playbook with permissions
      iii. Execute a cron job to check servers up-time by 12am.
      
  ![Ansible-playbook](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/eb0f88eb-33c2-49a0-a03a-edebc0c55bc7)
  
   Proof of Application's Accessibility on my slave. (192.168.33.11) 
   ![SlaveApplcation](https://github.com/iamwilliamsharrison/lamp_project/assets/62039530/cecfeb13-5416-4261-84b3-3e3d56060348)


