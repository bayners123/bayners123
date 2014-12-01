---
---

# ********************
# THE PART II DEADLINE:
# CHANGE THIS!
# ******************** 

deadline = new {{ site.countdown }}

# ********************
# THE PART II DEADLINE  ^
# CHANGE THIS!          |
# ********************

# DEFINITIONS: ------------------------

# Define a week counter, including the weeks :

FlipClock.Time = FlipClock.Time.extend

  getWeekCounter: (includeSeconds) ->
    digits = [
      this.getWeeks(),
      this.getDays(true),
      this.getHours(true),
      this.getMinutes(true)
    ]

    if(includeSeconds) 
      digits.push this.getSeconds(true)


    return this.digitize(digits)

# Define a clock face that has weeks :

FlipClock.CharlesCounterFace = FlipClock.Face.extend

  showSeconds: true

  # /**
  #  * Constructor
  #  *
  #  * @param  object  The parent FlipClock.Factory object
  #  * @param  object  An object of properties to override the default
  #  */

  constructor: (factory, options) ->
    this.base(factory, options)


  # /**
  #  * Build the clock face
  #  */

  build: (time) ->
    t = this;
    children = this.factory.$el.find('ul');
    offset = 0;

    time = if time then time else this.factory.time.getWeekCounter(this.showSeconds);

    if(time.length > children.length) 

      $.each time, (i, digit) ->
        t.createList(digit);

    if(this.showSeconds) 
      $(this.createDivider('Seconds')).insertBefore(this.lists[this.lists.length - 2].$el);
    else
      offset = 2;


    $(this.createDivider('Minutes')).insertBefore(this.lists[this.lists.length - 4 + offset].$el);
    $(this.createDivider('Hours')).insertBefore(this.lists[this.lists.length - 6 + offset].$el);
    $(this.createDivider('Days')).insertBefore(this.lists[this.lists.length - 8 + offset].$el);
    $(this.createDivider('Weeks', true)).insertBefore(this.lists[0].$el);

    this.base();


  # /**
  # * Flip the clock face
  # */

  flip: (time, doNotAddPlayClass) ->
    if(!time)
      time = this.factory.time.getWeekCounter(this.showSeconds)

    this.autoIncrement()

    this.base(time, doNotAddPlayClass)
    
# INITIATION ---------------

element = $('.flipclock')

# Once the DOM is loaded...
$(document).ready ->

# Initiate the clock
today = new Date()
timeLeft = (deadline - today) / 1000

clock = element.FlipClock (if timeLeft > 0 then timeLeft else 0) , 
  countdown: true
  clockFace: 'CharlesCounter' # Custom clock face, defined earlier