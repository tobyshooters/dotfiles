#!/usr/bin/env python3.13

import os
import subprocess
import threading

from anthropic import Anthropic


def prompt(lines, color=None):
    cmd = "dmenu -i -l 30 -p 'Claude:'"
    if color:
        cmd += f" -sb '{color}'"

    text = "\n".join(lines)

    result = subprocess.run(
            cmd, input=text, shell=True, text=True, capture_output=True)

    if result.returncode == 0:
        return result.stdout.strip()

    return None


def loading_start(lines):
    "Show loading dmenu in background"

    def fn():
        display_lines = ["Querying...", ""] + lines
        prompt(display_lines, "#ff6600")

    thread = threading.Thread(target=fn)
    thread.daemon = True
    thread.start()
    return thread


def loading_end():
    "Kill any remaining dmenu processes"
    subprocess.run("pkill dmenu", shell=True)


def wrap(lines, max_length):
    "Break lines longer than max_length on word boundaries."
    result = []

    for line in lines:
        if len(line) <= max_length:
            result.append(line)
            continue

        curr = ""
        for word in line.split():
            if not curr:
                curr = word
            elif len(curr) + 1 + len(word) <= max_length:
                curr += " " + word
            else:
                result.append(curr)
                curr = word

        if curr:
            result.append(curr)

    return result


def main():
    try:
        with open(os.path.expanduser("~/dotfiles/anthropic")) as f:
            api_key = f.read().strip()

        query = prompt([])
        if not query:
            return

        client = Anthropic(api_key=api_key)
        lines = [query]

        while True:
            loading_start(lines)
            try:
                response = client.messages.create(
                    model="claude-3-5-sonnet-20241022",
                    max_tokens=1000,
                    messages=[{"role": "user", "content": query}]
                )
            finally:
                loading_end()

            lines += [""]
            lines += wrap(response.content[0].text.split('\n'), 80)
            lines += [""]

            selection = prompt(lines)

            if not selection:
                break

            if selection in lines:
                cmd = "xclip -selection clipboard"
                subprocess.run(cmd, input=selection, text=True, shell=True)
                break

            query = selection
            lines += [query]

    except Exception as e:
        prompt([f"Error: {str(e)}"])


if __name__ == "__main__":
    main()
