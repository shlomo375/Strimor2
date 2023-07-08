import os
from moviepy.editor import ImageSequenceClip

image_folder = "ObstacleVideo"
output_video = "video.mp4"
fps = 30  # Frames per second

# Get the list of image files in the folder
images = sorted(os.listdir('./'))
image_files = [os.path.join(img) for img in images if img.endswith(".png")]

# Create the video clip from the image files
clip = ImageSequenceClip(image_files, fps=fps)

# Write the video to the output file
clip.write_videofile(output_video, codec="libx264", fps=fps, preset="medium")
