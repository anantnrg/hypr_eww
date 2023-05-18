#! /bin/bash
workspace=$1

echo "Switching to workspace $workspace"
hyprctl dispatch workspace $workspace
