Bash script to send Amazon SNS messages
=======================================

The `snssend` script is a companion to Rawr, providing the ability to send push notifications to Rawr via Amazon Simple Notification Service (SNS) and the Apple Push Notification Service (APNS). To send a push notification, run:

    snssend devicename soundfile

Where `devicename` is the name of a device listed in the device file (see below) and `soundfile` is the name of a file (sans-extension) in the Rawr app bundle.

## Requirements
To effectively use `snssend`, you'll need:

* A current Apple iOS Developer (or Enterprise Developer) Program membership
* A specific (not wildcard) bundle ID assigned to Rawr
* A push notification certificate issued by Apple for the Rawr bundle ID
* An Amazon Web Services account with Simple Notification Service enabled

Configuring much of this is beyond the scope of this document, however, none of it is particularly complex and both Apple and Amazon have good documentation.

## Configuration
Before use, you'll need to open the script in your favourite text editor and 
set a few configuration options. There are two additional files necessary: 
`.snsrequestid`, which tracks the request ID across sessions to ensure 
uniqueness; and `.snsdevices`, which contains a list of easy-to-remember 
device names linked to their endpoint ARNs. Both these files are stored in 
your home folder by default.

You'll also need to set the AWS server endpoint, which corresponds to the 
region you selected for your SNS app; the default is the US-East (North 
Virginia) region.

### AWS Credentials
It's suggested that you use a set of IAM credentials with only sufficient 
access to perform the required functionality, rather than just using your 
AWS root account. If you're already setup for the AWS Command Line Interface: 
job done. If not, you'll need to follow the setup procedure described in the 
[AWS Command Line Interface documentation][AWSCLI-Docs].

> **NOTE:** The script supports the AWS CLI config with a few exceptions: 
> the config file is used _before_ the environment variables; non-default 
> profile support is experimental; and tokens are not supported.

[AWSCLI-Docs]: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

### Device Identifiers
In order to send APNS notifications to a device, you need to tell Amazon the 
APNS device token. Amazon assigns an endpoint ARN for each device token you 
register, and it's the ARN you use when sending an APNS message via SNS.

Specifying the ARN on the command line is ugly and difficult, so there's a configuration file that allows you to alias a name for each endpoint ARN. The default location for this file is `~/.snsdevices`, but this can be changed in the script's header. The format is as follows:

	devicename=arn

Where `devicename` is the case-sensitive handle you'll use on the command line and `arn` is the Amazon SNS endpoint ARN, as provided in the SNS Management Console.
