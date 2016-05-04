# Getting Set-up with AWS

These instructions will be brief, and are intended to supplement an explanation at the lecture IRL. If you are reading this long after May 3, 2016 these instructions may be out of date.

There are two ways to rent instances from AWS EC2. On-Demand instances cost more, but they're yours as long as you have money to spend. Spot Instances cost less, but there is a chance (possibly insignificant) that Amazon will kick you off the instance earlier than you may like.

## On-Demand Instances

It's as easy as 1, 2, ..., 3*7.

1. Sign in using the information you received when you requested an account (Should include temporary password and login URL).
2. Follow the instructions about setting up a permanent password. You will land on the AWS Dashboard. Click on the EC2 service (should be one of the first icons).
3. Make sure you are in the us-east-1 (N. Virginia) region. (This region has the cheapest spot instances, as well as the AMI we'll be using).
4. Click 'Launch Instance'.
5. Select 'Community AMIs'.
6. Search for ami-5f789e32 and select it. If you cannot find this AMI, just search for "cudnn" and select an AMI that looks modern (Ubuntu 14.04+).
7. For "instance type", select g2.2xlarge (under "type").
8. Click "Next: Add Storage" at the bottom-right of the page.
9. Make sure the size of your Root Volume to 25GB. For some reason Amazon has a minimum root device size for different types of instances.
10. Click "Review and Launch" at the bottom of the page.
11. Click "Launch" near the bottom of the page.
12. Select "Create a new key pair" from the dropdown menu. (Or choose an existing one, if you already have one).
13. Name your key pair and download the private .pem file. Keep it somewhere where you can find it later. 
14. In terminal, go to where you downloaded your .pem file and type "chmod 400 [yoursecretkey.pem]". You only have to do this once, whenever you create a new key.
15. Back in the browser, click "Launch Instances".
16. Go to your EC2 dashboard.
17. Click "Running Instances".
18. Refresh the module or page periodically until your instance is in a running state.
19. Select the instance and click "Connect".
20. Follow the instructions in the pop-up. (Make sure you're in the same directory as your .pem file!).
21. Done! Hopefully you are connected to your EC2 instance now.

## Spot Instances

If this is your first time using AWS, know that spot pricing will only save you tens of cents on the hour and your instance may be shut off at any moment by Amazon, so the cons may outweigh the seemingly small benefits. But if you intend to use AWS EC2 instances often, it may be worth learning how to request spot instances (it's not difficult). Tens of cents is often 50-90% off the on-demand instance price, and 2-10 times more compute time for your money can go a long way.

The instructions are nearly the same as above, except between steps 6 and 7 go to the tab labeled "Configure Instance" and check the box that says "Request Spot Instances". There will appear the current minimum prices you must bid to instantly get an instance in that region. If you bid $0.2/hr for a spot instance, and a few hours later the minimum bid in your specific region (which Amazon will assign to you, e.g. "us-east-1a") rises above $0.2, Amazon will give you a 2 minute warning, then terminate your instance. Depending on the recent pricing history of the region and the specific instance type you request, prices can fluctuate anywhere from a few cents to a few dollars(!) over a 2-3 hour period. Usually you will be more than safe bidding 125% or so of the current lowest bid price. Different regions have different spot instance prices. This is why, while our club is based in Seattle, WA, we are using spot instances in the N. Virginia region. Spot prices for g2.2xlarge instances have recently been mercurial in western regions, but consistently cheap in the N. Virginia region.
