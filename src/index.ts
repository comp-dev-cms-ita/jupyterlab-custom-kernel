import { JupyterFrontEnd, JupyterFrontEndPlugin } from "@jupyterlab/application";
import { MainAreaWidget } from "@jupyterlab/apputils";
import { ILauncher } from "@jupyterlab/launcher";
import { extensionIcon } from "@jupyterlab/ui-components/lib/icon/iconimports";
import { KernelspecManagerWidget } from "./widget";
import 'core-js';

/*
 * The command IDs used by the to create a kernelspec.
 */
namespace CommandIDs {
  export const create = "jupyterlab-custom-kernel:create-kernelspec";
}

/**
 * Initialization data for the ksmm extension.
 */
const ksmmExtension: JupyterFrontEndPlugin<void> = {
  id: "jupyterlab-custom-kernel-plugin",
  autoStart: true,
  //optional: [ILauncher],
  activate: (app: JupyterFrontEnd, launcher: ILauncher) => {
    const { commands, serviceManager } = app;
    const command = CommandIDs.create;
    commands.addCommand(command, {
      caption: "A way to manage Kernelspecs",
      label: "Kernelspec Manager",
      icon: (args) => (args['isPalette'] ? null : extensionIcon),
      execute: () => {
        const content = new KernelspecManagerWidget(serviceManager);
        const widget = new MainAreaWidget<KernelspecManagerWidget>({ content });
        widget.title.label = "Kernelspec Manager";
        app.shell.add(widget, "main");
      }
    });
    if (launcher) {
      launcher.add({
        command
      });
    }
  }
}

export default ksmmExtension;
