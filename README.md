# Egg-Master

This is an egg timer to boil with your favorite york.

Notes:
Apple dose not allow us to take control when the app is on background.
What I tried to get the alart when it is time is 2 methods after the app went back to background and these are the fact 
what I found out...

1. Using End Background Task (Currently commented out in App delegate)\n
    The time the app can keep running on the background is limited. So if you want to keep running for over 30 mins, 
    this method will not be suited.
    
2. Local Notification \n
    The sound will not play if the device is on the silent mode. And sound can play only for 30 sec.
