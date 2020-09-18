require 'securerandom'

module Jekyll
  class VideoBackgroundTag < Liquid::Block
    def initialize(tag_name, input, tokens)
      super
      @tag_id = SecureRandom.hex(4)
      @video_id = input.strip
    end
    
    def render(context)
      innerHTML = super
      %Q[
<div class="video-background video-#{@tag_id}">
  <div class="video">
    <div class="background">
      <div id="yt-player-#{@tag_id}"></div>
    </div>
  </div>
  <div class="video-overlay" style="background-image: url('https://img.youtube.com/vi/#{@video_id}/maxresdefault.jpg');"></div>
  <div class="content">
    #{innerHTML}
  </div>
</div>
<script>
(function(){
  const oldOnYouTubeIframeAPIReady = window.onYouTubeIframeAPIReady;
  const playerOptions = {
    autoplay: 1,
    mute: 1,
    autohide: 1, 
    modestbranding: 1, 
    rel: 0, 
    showinfo: 0, 
    controls: 0, 
    disablekb: 1, 
    enablejsapi: 1, 
    iv_load_policy: 3,
    loop: 1,
    playlist: '#{@video_id}'
  }
  
  let ytPlayer;
  function onYouTubeIframeAPIReady() {
    ytPlayer = new YT.Player('yt-player-#{@tag_id}', {
      width: '1280',
      height: '720',
      videoId: '#{@video_id}',
      playerVars: playerOptions,
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    });
    oldOnYouTubeIframeAPIReady && oldOnYouTubeIframeAPIReady();
  }
  window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;
  
  function onPlayerReady(event) {
    event.target.playVideo();
    const videoDuration = event.target.getDuration();
    setInterval(function (){
      const videoCurrentTime = event.target.getCurrentTime();
      const timeDifference = videoDuration - videoCurrentTime;
      
      if (2 > timeDifference > 0) {
        event.target.seekTo(0);
      }
    }, 1000);
  }
  
  function onPlayerStateChange(event) {
    if (event.data == YT.PlayerState.PLAYING) {
      const videoOverlay = document.querySelector('.video-#{@tag_id} .video-overlay');
      videoOverlay.classList.add('fade-out');
    }
  }

})();
</script>
      ]
    end
  end
end

Liquid::Template.register_tag("videobackground", Jekyll::VideoBackgroundTag)
