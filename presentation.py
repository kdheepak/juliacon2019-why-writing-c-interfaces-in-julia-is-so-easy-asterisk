# -*- coding: utf-8 -*-
import time
import libtmux


def main():
    session = libtmux.Server().list_sessions()[0]

    w = session.new_window(attach=False, window_name="example1")
    w.split_window(attach=False, vertical=False)

    p = w.children[0]
    p.clear()
    p.send_keys("vim c/example1.c")

    w = session.new_window(attach=False, window_name="main")
    w.split_window(attach=False, vertical=False)

    p = w.children[0]
    p.clear()
    p.send_keys("vim c/main.c julia/main.jl")

    w = session.new_window(attach=False, window_name="user")
    w.split_window(attach=False, vertical=False)

    p = w.children[0]
    p.clear()
    p.send_keys("vim c/user.c")

    p = w.children[1]
    p.clear()
    p.send_keys("vim julia/user.jl")

    w = session.new_window(attach=False, window_name="example2")
    w.split_window(attach=False, vertical=False)

    p = w.children[0]
    p.clear()
    p.send_keys("vim c/example2.c")

    w = session.new_window(attach=False, window_name="example3")
    w.split_window(attach=False, vertical=False)

    p = w.children[0]
    p.clear()
    p.send_keys("vim c/example3.cpp")

    w = session.new_window(attach=False, window_name="example4")
    w.split_window(attach=False, vertical=False)

    p = w.children[0]
    p.clear()
    p.send_keys("vim c/example4.cpp")

    session.attached_window.children[0].send_keys("make slides")


if __name__ == "__main__":
    main()
