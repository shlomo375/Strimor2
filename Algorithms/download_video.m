function download_video(url)
    command = ['youtube-dl --verbose -f ''bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'' -o ''%(title)s.%(ext)s'' ', url];
    [status, commandOut] = system(command);
    if status ~= 0
        error('Failed to download video: %s', commandOut);
    end
end