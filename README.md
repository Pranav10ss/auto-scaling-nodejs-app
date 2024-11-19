# Auto Scaling Node.js App on AWS
## 📌Purpose of the project
This project demonstrates how to set up an Auto Scaling and Load Balancing solution for a Node.js app hosted on AWS EC2 instances using an Application Load Balancer (ALB) and an Auto Scaling Group (ASG).
The application is a simple Node.js app that runs on EC2 instances. The app has an auto-scaling configuration to ensure high availability and performance under load. The Application Load Balancer (ALB) distributes traffic across EC2 instances, while Auto Scaling adjusts the number of EC2 instances based on CPU utilization.
## Architecture
![Diagram explaining the architecture of this project](Images/Architecture-diagram.svg)
### Key Components:
1. **Node.js app** running on EC2 instances
2. **Application Load Balancer (ALB)** to balance traffic
3. **Auto Scaling Group (ASG)** to scale instances based on CPU utilization
4. **GitHub repository** with the app code
5. The **Launch Template** in the above project is a reusable configuration that defines the settings for launching EC2 instances. It simplifies and standardizes the setup process for your Auto Scaling Group (ASG) and ensures that new instances are launched with consistent configurations.
   * The launch template defines the AMI ID, instance type, key pair, security groups, and user data script. This ensures
     that all instances launched by the ASG have the same setup.
   * The launch template includes the **user data script**, which installs the necessary software, clones the app code from your
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
* Under `advanced details`, Use the **User Data script** (included in the repo) to install necessary dependencies like Git and Node.js, clone the app code, install 
  dependencies, and start the app.
* After pasting the user data script in the userdata section, click on create template.
### Step 3 - Create an Auto Scaling group
* Select the **Launch template** that you created. Select the Version of LT as `Latest(1)`. Under Network Settings, choose the default VPC and select the AZs and subnets. 
  Select the following AZs: `us-east-1a`, `us-east-1b`, `us-east-1c`
* Under Advanced options, Attach a **new load balancer** and choose Application load balancer. Select the load balancer scheme as **Internet-facing**. Change the Listner 
  Port to `3000`. Create a **target group** for the load balancer to route/forward the incoming traffic to instances.
* Configure the Auto scaling group's size and scaling policies. Set the **Desired capacity** as `2`, **Minimum capacity** as `2` and **maximum capacity** as `3`.
* Choose **Target tracking scaling policy** and select the **Metric type** as `Avg. CPU Utilization`. Set the **Target value** as `25%` to trigger scaling actions.
## 🔍Testing
* Once the instances are up and running you can grab its public IPv4 address and direct it to port 3000 to check if the app is running properly. If the Ipv4 address is 
  54.236.29.52, add the port 3000 to it. For example, `54.236.29.52:3000`. If everything is configured well you can see the app's page display without a problem.
* You can test the second instance in the same way.
* Go to Load balancer-> copy its DNS name and hit that in a browser by directing it to port 3000. We can also change the listner of the load balancer from 3000 to to its 
  default port 80 for it to work.
  
### Testing the Auto Scaling of EC2 instances
* Terminate one of the instances. If you see the browser with IP address of the terminated instance, you can see that the requested is timed out because the server is down.
* Since the minimum capacity was set to 2, the ASG will spin up a new EC2 instance in order to meet the requirement. Once the new instance is successfully running, you
  can check its IPv4 adress by targetting it to port 3000 to check whether the app is running.
### Adding some load to the existing instances to trigger the scaling policies and add an extra instance
* SSH into one of the instances and execute the following commands to add stress.
  
The below command installs extra package on a Amazon Linux instance.
  ```
  sudo amazon-linux-extras install epel -y
  ```
  The below command Installs the stress utility from the EPEL repository.
  ```
  sudo yum install stress -y
  ```
  The below command Starts the stress utility to put load on the system's CPU.
  ```
  sudo stress --cpu 2
  ```
  After executing the above commands, if you check the **monitoring** tab of any instance you'll see the CPU utilization going up. Once the CPU Utilization(%) crosses 25% the ASG scaling policy will trigger & increases the instance count from 2 to 3(Maximum capacity). Now theres 3 instances running in each availability zones.

## Conclusion
This project demonstrates how to automatically scale a **Node.js** application on AWS using EC2, ALB, and ASG. It shows how AWS services like Auto Scaling and Load Balancers can ensure high availability and performance for your application.
