#!/usr/bin/env python3

import os
import logging
import argparse
from pathlib import Path

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("input", default=".", help="Input directory of the template")
    parser.add_argument("-o", "--output", default="-", help="Output Path of the generated Dockerfiles")
    parser.add_argument("--analysis", help="Enable RStudio and Jupyter Notebook for analysis", action="store_true")
    parser.add_argument("--desktop", help="Enable Desktop", action="store_true")
    return parser.parse_args()

def create_dockerfile(base_image, template_file):
    logger.debug(f"Creating Dockerfile from {base_image} with template {template_file}")
    dockerfile = Path(template_file).read_text().replace("{% BASE_IMAGE %}", base_image)

    image_name = next(l.strip().split(" ")[-1] for l in dockerfile.splitlines()[::-1] if l.startswith("FROM"))

    return dockerfile, image_name



def main():
    args = arg_parser()

    dockerfile_dir = Path(args.input)/"Dockerfile.d"
    dockerfiles = []


    dockerfile, image_name = create_dockerfile("", dockerfile_dir/"00-os-base")
    dockerfiles.append(dockerfile)
    if args.desktop:
        dockerfile, image_name = create_dockerfile(image_name, dockerfile_dir/"05-desktop-base")
        dockerfiles.append(dockerfile)
    if args.analysis:
        dockerfile, image_name = create_dockerfile(image_name, dockerfile_dir/"10-analysis-base")
        dockerfiles.append(dockerfile)
    dockerfile, _ = create_dockerfile(image_name, dockerfile_dir/".."/"Dockerfile")
    dockerfiles.append(dockerfile)

    dockerfile = "\n\n".join(dockerfiles)
    if args.output == "-":
        print(dockerfile)
    else:
            Path(args.output).write_text(dockerfile)

if __name__ == "__main__":
    main()