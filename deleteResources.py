import os
import subprocess

def run_terraform_destroy(paths):
    for path in paths:
        try:
            print(f"Changing directory to {path}")
            os.chdir(path)

            print(f"Running 'terraform destroy' in {path}...")
            result = subprocess.run(
                ["terraform", "destroy", "-auto-approve"],
                capture_output=True,
                text=True,
            )

            if result.returncode == 0:
                print(f"Successfully destroyed resources in {path}\n")
            else:
                print(f"Failed to destroy resources in {path}. Error:\n{result.stderr}")
        except Exception as e:
            print(f"An error occurred while processing {path}: {e}")
        finally:
            # Return to the initial directory to avoid issues with relative paths
            os.chdir(initial_dir)

# List of paths to Terraform environment directories
terraform_paths = [
    "/home/mad/terraform/stages/dev",
    "/home/mad/terraform/stages/qa",
    "/home/mad/terraform/stages/uat",
    "/home/mad//terraform/stages/prod",
]

if __name__ == "__main__":
    # Save the initial directory
    initial_dir = os.getcwd()

    print("Starting Terraform destroy process...")
    run_terraform_destroy(terraform_paths)
    print("Terraform destroy process completed.")
