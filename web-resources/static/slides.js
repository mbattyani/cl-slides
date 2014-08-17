function enterFullScreen() {
    if (document.documentElement.requestFullscreen) {
      document.documentElement.requestFullscreen();
    } else if (document.documentElement.msRequestFullscreen) {
      document.documentElement.msRequestFullscreen();
    } else if (document.documentElement.mozRequestFullScreen) {
      document.documentElement.mozRequestFullScreen();
    } else if (document.documentElement.webkitRequestFullscreen) {
      document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
    }
}

function exitFullScreen() {
    if (document.exitFullscreen) {
      document.exitFullscreen();
    } else if (document.msExitFullscreen) {
      document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
      document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
      document.webkitExitFullscreen();
    }
}

function toggleFullScreen() {
  if (!document.fullscreenElement &&    // alternative standard method
      !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement )
      enterFullScreen();
    else
        exitFullScreen();
}

function enableToggleFullScreen() {
    document.addEventListener('keydown', function(e) {
        console.log('key=' + e.keyCode);
        if (e.keyCode == 13) {
            toggleFullScreen();
        }
    }, false);
}

function enableNavKeys() {
    document.addEventListener('keydown', function(e) {
        console.log(e.keyCode);
        if (e.keyCode == 13) {
            toggleFullScreen();
        }
        else if (e.keyCode == 78) { // N
                nextSlide();
            }
        else if (e.keyCode == 80) { // P
                prevSlide();
            }
        else if (e.keyCode == 83) { // S
                resetSlides();
            }
    }, false);
}

var currentSlide = null;

function hideSlide(n) {
    console.log('hideSlide'+n);
    if (n != null) {
        var args = slidesArgs[n];
        fgt(args[0]).style.WebkitTransform = args [1];
    }
}

function showSlide(n) {
    console.log('showSlide'+n);
    if (n != null) {
        var args = slidesArgs[n];
        fgt(args[0]).style.WebkitTransform = 'scale(1)';
    }
}

function nextSlide() {
    console.log('nextSlide');
    var nextSlide = 0;
    if (currentSlide != null) {
        nextSlide = slidesArgs[currentSlide][2];
        hideSlide(currentSlide);
        currentSlide = null;
    }
    if (nextSlide != null) {
        showSlide(nextSlide);
        currentSlide = nextSlide;
        }
}

function prevSlide() {
    var nextSlide = null;
    if (currentSlide != null) {
        nextSlide = slidesArgs[currentSlide][3];
        hideSlide(currentSlide);
        currentSlide = null;
    }
    if (nextSlide != null) {
        showSlide(nextSlide);
        currentSlide = nextSlide;
        }
}
