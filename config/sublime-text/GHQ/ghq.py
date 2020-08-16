import sublime
import sublime_plugin
import subprocess

def get_ghq_repositories():
    settings = sublime.load_settings('GHQ.sublime-settings')
    ghq_command = settings.get('ghq_command')

    stdout = subprocess.check_output([ghq_command, 'list', '--full-path'])
    repos = stdout.decode().rstrip('\n').split('\n')
    return repos


def open_repository(window, repository_path):
    window.run_command('close_all')

    folders = [{ 'path': repository_path }]
    window.set_project_data({ 'folders': folders })


class GhqOpenRepositoryCommand(sublime_plugin.WindowCommand):
    def run(self):
        try:
            repositories = get_ghq_repositories()

            def on_repository_selected(index):
                if index >= 0:
                    open_repository(self.window, repositories[index])

            self.window.show_quick_panel(repositories, on_repository_selected)

        except Exception as e:
            sublime.error_message(str(e))
