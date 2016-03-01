# Setup

We will assume you are working in a Linux-like environment (includes OS X).

## On Your Own Computer

We highly recommend installing the [Anaconda Python distribution](https://www.continuum.io/downloads). This will install many commonly used (and not so commonly used, but useful) Python libraries on your machine, in addition to your favorite version of Python (usually 2.7 or 3.5), iPython, Jupyter Notebook, etc.

If you are very confident in your system administration skills, you may install the dependencies from scratch then run the code below instead.

Once you have pip and the rest of the Keras dependencies (comes with the Anaconda Python distro above) open a terminal and type
'''
$ sudo pip install Keras
'''
(Note, the $ is meant to signify that you are using the bash terminal. Do not type $.)

Or if you like bleeding edge versions
'''
$ sudo pip install git+git://github.com/fchollet/keras.git
'''

We recommend that you install the bleeding edge version of Theano (or TensorFlow, if you prefer and/or know how).
'''
$ sudo pip install git+git://github.com/Theano/Theano.git
'''

After that, you should be ready to go! Set up a Jupyter Notebook or just call
'''
$ ipython
Python 2.7.3 (default, Jun 22 2015, 19:33:41) 
Type "copyright", "credits" or "license" for more information.

IPython 4.1.1 -- An enhanced Interactive Python.
?         -> Introduction and overview of IPython's features.
%quickref -> Quick reference.
help      -> Python's own help system.
object?   -> Details about 'object', use 'object??' for extra details.

In [1]: from Keras.models import Sequential
'''
And you're on your way.

## On AWS
These instructions will be brief, and are intended to supplement an explanation at the lecture IRL. If you are reading this long after March 2, 2016 these instructions may be out of date.

There are two ways to rent instances from AWS EC2. On-Demand instances cost more, but they're yours as long as you have money to spend. Spot Instances cost less, but there is a chance (possibly insignificant) that Amazon will kick you off the instance earlier than you may like.

### On-Demand Instance

1. Sign into the AWS Management Console
2. Go to the EC2 service (should be one of the first icons)
3. Make sure you are in the us-east-1 (N. Virginia) region.\*
3. Click 'Launch Instance'.
4. Select 'Community AMIs'.
5. Search for ami-5cc6e636 and select it. If you cannot find this AMI, just search for "cudnn" and select whichever AMI appeals to you the most.
6. For "instance type", select g2.2xlarge (under "type").
7. Click "Add Storage" near the top of the page.
8. Get rid of the 200GB EBS magnetic volume. We won't need that much space. Leave the rest of the volumes as is.
9. Click "Review" near the top of the page.
10. Click "Launch" near the bottom of the page.
11. Select "Create a new key pair" from the dropdown menu.
12. Name your key pair and download the private .pem file. Keep it somewhere where you can find it later (Like your home directory).
13. Click "Launch Instances".
14. Go to your EC2 main page.
15. Click "Running Instances".
16. Refresh the page periodically until your instance is in a running state.
17. Select the instance and click "Connect".
18. Follow the instructions in the pop-up.
19. Done! Hopefully you are connected to your EC2 instance now.

### Spot Instances

If this is your first time using AWS and you already received your $100 AWS Educate credit, know that spot pricing will only save you tens of cents on the hour and your instance may be shut off at any moment by Amazon, so the cons may outweigh the seemingly small benefits. But if you intend to use AWS EC2 instances often, it may be worth learning how to request spot instances. Tens of cents is often 50-90% off the on-demand instance price, and 2-10 times more compute time for your money can go a long way.

The instructions are nearly the same as above, except between steps 6 and 7 go to the tab labeled "Configure Instance" and check the box that says "Request Spot Instances". There will appear the current minimum prices you must bid to instantly get an instance in that region. If you bid $0.2/hr for a spot instance, and a few hours later the minimum bid in your specific region (which Amazon will assign to you, e.g. "us-east-1a") rises above $0.2, Amazon will give you a 2 minute warning, then terminate your instance. Depending on the recent pricing history of the region and the specific instance type you request, prices typically only fluctuate either a few cents or a few dollars(!) - but not in between - over a 2-3 hour period. Usually you will be more than safe bidding 125% or so of the current lowest bid price. Different regions have different spot instance prices. This is why, while our club is based in Seattle, WA, we are using spot instances in the N. Virginia region. Spot prices for g2.2xlarge instances have been mercurial in western regions, but consistently cheap in the N. Virginia region.
