# Auto Scaling Node.js App on AWS
## 📌Purpose of the project
This project demonstrates how to set up an Auto Scaling and Load Balancing solution for a Node.js app hosted on AWS EC2 instances using an Application Load Balancer (ALB) and an Auto Scaling Group (ASG).
The application is a simple Node.js app that runs on EC2 instances. The app has an auto-scaling configuration to ensure high availability and performance under load. The Application Load Balancer (ALB) distributes traffic across EC2 instances, while Auto Scaling adjusts the number of EC2 instances based on CPU utilization.
## Architecture
![Diagram explaining the architecture of this project](Images/Architecture-diagram.svg)
### Key Components"
1. **Node.js app** running on EC2 instances
2. **Application Load Balancer (ALB)** to balance traffic
3. **Auto Scaling Group (ASG)** to scale instances based on CPU utilization
4. **GitHub repository** with the app code
5. The **Launch Template** in the above project is a reusable configuration that defines the settings for launching EC2 instances. It simplifies and standardizes the setup process for your Auto Scaling Group (ASG) and ensures that new instances are launched with consistent configurations.
   * The launch template defines the AMI ID, instance type, key pair, security groups, and user data script. This ensures
     that all instances launched by the ASG have the same setup.
   * The launch template includes the user data script, which installs the necessary software, clones the app code from your
     GitHub repo, and starts the Node.js app automatically on instance startup. This eliminates the need for manual setup.
   * The ASG uses the launch template to create new instances dynamically when scaling out. The template ensures that the
     new instances match the desired configuration.
   
## Steps to Build the Project
The project was implemented with the following AWS services:
### Step 1 - Create a security group
* Go to EC2 console -> Create a security group by choosing the default VPC and add the following inbound rules inbound rule.
  1. SSH ------------ Port 22 ----------- Source: Anywhere(0.0.0.0/0)
  2. HTTP ----------- Port 80 ----------- Source: Anywhere(0.0.0.0/0)
  3. HTTPS ---------- Port 443 ---------- Source: Anywhere(0.0.0.0/0)
  4. Custom --------- Port 3000 --------- Source: Anywhere(0.0.0.0/0)
We need to add a custom TCP rule on Port 3000 because that's the Port app runs on.
### Step 2 - Create Launch template to automate the EC2 instance launch process
* Select an AMI and select the instance type as t2.micro
* In network settings, select the security group that you created.
* Under advanced detailsUse the User Data script (included in the repo) to install necessary dependencies like Git and Node.js, clone the app code, install dependencies, and start the app.
