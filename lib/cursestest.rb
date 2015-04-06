require 'curses'

Curses.init_screen

loop {
  ch = Curses.getch
  case ch
    when Curses::KEY_BACKSPACE
      Curses.addstr('Backspace \n')
    else
      Curses.addstr("Key: #{ch} \n")
  end
}

Curses.close_screen