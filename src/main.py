#!/usr/bin/python
import os
import gi
gi.require_version("Gtk", "3.0")
gi.require_version('AppIndicator3', '0.1')
from gi.repository import Gtk as gtk, AppIndicator3 as appindicator
import subprocess

def main():
  indicator = appindicator.Indicator.new("Duplicity indicator", "starred-symbolic", appindicator.IndicatorCategory.APPLICATION_STATUS)
  indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
  indicator.set_menu(menu())
  # indicator.set_menu(subprocess.call("./d2.sh"))
  gtk.main()

def menu():
  menu = gtk.Menu()
  # start_backup()
  command_one = gtk.MenuItem('Start backup')
  command_one.connect('activate', start_backup)
  menu.append(command_one)
  command_two = gtk.MenuItem('Show progress')
  command_two.connect('activate', show_progress)
  menu.append(command_two)
  exittray = gtk.MenuItem('Exit Tray')
  exittray.connect('activate', quit)
  menu.append(exittray)
  menu.show_all()
  return menu

def start_backup(_):
  subprocess.call("./modules/duplicity_backblaze.sh")

def show_progress(_):
  os.system("gedit $HOME/Documents/notes.txt")

def quit(_):
  gtk.main_quit()

if __name__ == "__main__":
  main()
  # duplicity = subprocess.call("./d2.sh")
  # gtk.main_quit()
