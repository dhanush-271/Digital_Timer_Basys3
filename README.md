TIMER IMPLEMENTATION ON BASYS3

**KOTHAPALLI DHANUSH**

1\.Introduction

This report presents the design and implementation of a digital watch timer using Verilog hardware description language (HDL). The primary objective of this project is to develop a functional watch timer that can perform basic timekeeping functions, including starting, stopping, and resetting the timer, as well as editing the time settings. The watch timer is designed to be user-friendly and efficient, capable of displaying time accurately on a seven-segment display.

2\.Working Principle

The watch timer designed in this project operates based on a finite state machine (FSM) to manage its various functionalities. The main principles guiding the operation of this watch timer are:

1. **Clock Division:** The primary clock signal is divided to create a slower clock signal (**sclk**) suitable for human-readable time display. This slower clock ensures the timer increments every second rather than at the high frequency of the primary clock.
1. **State Machine:** The FSM controls the different states of the watch timer, including idle (**e0**), editing (**e1**), and running (**start\_sig**). Transitions between these states are triggered by input signals (**reset, start, edit, edit\_shift, inc**).
1. **Time Counting:** The watch timer maintains separate registers for seconds and minutes, updating them based on the slower clock signal. The timer decrements these values starting from the values set by the user.
1. **User Interface:** Input signals given using the push buttons of Basys3 board allow the user to control the timer's operation. These include:
   1. reset: Resets the timer to zero.
   1. start: Starts or stops the timer.
   1. edit: Enters the editing mode to adjust time settings.
   1. edit\_shift: Shifts between editing minutes and seconds.
   1. inc: Increments the selected time setting (either minutes or seconds).
1. **Display:** The current time is displayed using a seven-segment display module, which converts the binary time values into a human-readable format.

3\.States of operation

The FSM manages the watch timer through the following states:

**e0: Idle state**

The initial state where the timer is inactive.

Operations:

- If reset is active, the timer resets the seconds and minutes to zero.
- If edit is active, the state transitions to the editing state (e1).
- If start is active, the state transitions to the running state (start\_sig).

Outputs: edit\_conf, start\_conf, and shift\_conf are cleared.

**start\_sig: Running State**

The timer is active and counting down.

Operations:

- If reset is active, the timer resets the seconds and minutes to zero.
- If start is active again, the state transitions back to the idle state (e0).
- On every slow clock pulse (sclk), the timer decrements the seconds and minutes accordingly.
- If both minutes and seconds reach zero, the state transitions to the idle state (e0).

Outputs: start\_conf is cleared when the state is idle, indicating that the timer has stopped.

**e1: Editing State**

The timer is in editing mode, allowing the user to adjust the time settings.

Operations:

- If reset is active, the timer resets the seconds and minutes to zero.
- If edit is active again, the state transitions back to the idle state (e0).
- If edit\_shift is active, the editing focus shifts between minutes and seconds.
- If inc is active, the selected time setting (either minutes or seconds) is incremented.

Outputs: edit\_conf and shift\_conf are cleared when the state is idle, indicating the end of editing.

**Default State**

The state machine defaults to the idle state (e0) if an undefined state is encountered.

Operations:

- The timer maintains its current seconds and minutes values.

Outputs: The state transitions to e0, ensuring a known operational state.



4\.Summary and output

The watch timer operates through a well-defined FSM with three primary states: idle (e0), running (start\_sig), and editing (e1). Each state has specific input triggers and operations, ensuring smooth transitions and accurate timekeeping. The integration of a slow clock signal and user interface controls allows for a functional and user-friendly watch timer design.

<https://drive.google.com/file/d/13iZivecyx6aCGSf0qMe6Oc4PqpupkD4g/view?usp=sharing>


