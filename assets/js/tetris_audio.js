class TetrisAudio {
  constructor() {
    this.audioContext = null;
    this.masterVolume = 0.3;
    this.enabled = true;
    this.sidPlayer = null;
    this.sidLoaded = false;
    this.userInteracted = false;
    this.initAudioContext();
    this.setupUserGestureHandler();
    this.initSID();
  }

  initAudioContext() {
    try {
      // Create audio context on first user interaction
      this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
      
      // Resume context if suspended (Chrome policy)
      if (this.audioContext.state === 'suspended') {
        document.addEventListener('click', () => {
          this.audioContext.resume();
        }, { once: true });
      }
    } catch (e) {
      console.warn('Web Audio API not supported');
      this.enabled = false;
    }
  }

  setupUserGestureHandler() {
    // Set up user gesture handler to enable audio
    const enableAudio = () => {
      this.userInteracted = true;
      
      // Resume our AudioContext if it exists and is suspended
      if (this.audioContext && this.audioContext.state === 'suspended') {
        this.audioContext.resume();
      }
      
      console.log('User interaction detected, audio enabled');
    };

    // Listen for various user interaction events
    ['click', 'keydown', 'touchstart'].forEach(event => {
      document.addEventListener(event, enableAudio, { once: true });
    });
  }

  initSID() {
    try {
      // Initialize jsSID player after user interaction
      if (typeof jsSID !== 'undefined') {
        // Delay SID initialization until after user gesture
        const initializeSID = () => {
          if (!this.sidPlayer) {
            this.sidPlayer = new jsSID(16384, 0.0005); // buffer length, background noise
            this.loadSIDFile();
            console.log('jsSID initialized after user interaction');
          }
        };

        // If user has already interacted, initialize immediately
        if (this.userInteracted) {
          initializeSID();
        } else {
          // Wait for user interaction
          ['click', 'keydown', 'touchstart'].forEach(event => {
            document.addEventListener(event, initializeSID, { once: true });
          });
        }
      } else {
        console.warn('jsSID library not available');
      }
    } catch (e) {
      console.warn('Error initializing SID player:', e);
    }
  }

  loadSIDFile() {
    try {
      if (this.sidPlayer) {
        // Use local file from Phoenix static assets
        const sidUrl = '/sounds/Sanxion.sid';
        
        this.sidPlayer.loadinit(sidUrl, 0); // subtune 0
        this.sidLoaded = true;
        console.log('Sanxion.sid loading initiated from local file:', sidUrl);
      }
    } catch (e) {
      console.warn('Error loading SID file:', e);
    }
  }

  createOscillator(frequency, type = 'square') {
    if (!this.enabled || !this.audioContext) return null;
    
    const oscillator = this.audioContext.createOscillator();
    oscillator.type = type;
    oscillator.frequency.setValueAtTime(frequency, this.audioContext.currentTime);
    return oscillator;
  }

  createGain(volume = 1) {
    if (!this.enabled || !this.audioContext) return null;
    
    const gainNode = this.audioContext.createGain();
    gainNode.gain.setValueAtTime(volume * this.masterVolume, this.audioContext.currentTime);
    return gainNode;
  }

  // Piece movement sound (short blip)
  playMove() {
    if (!this.enabled) return;
    
    const oscillator = this.createOscillator(800, 'square');
    const gain = this.createGain(0.1);
    
    if (!oscillator || !gain) return;
    
    oscillator.connect(gain);
    gain.connect(this.audioContext.destination);
    
    gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + 0.05);
    
    oscillator.start();
    oscillator.stop(this.audioContext.currentTime + 0.05);
  }

  // Piece rotation sound (quick chirp)
  playRotate() {
    if (!this.enabled) return;
    
    const oscillator = this.createOscillator(1200, 'square');
    const gain = this.createGain(0.12);
    
    if (!oscillator || !gain) return;
    
    oscillator.connect(gain);
    gain.connect(this.audioContext.destination);
    
    oscillator.frequency.exponentialRampToValueAtTime(800, this.audioContext.currentTime + 0.08);
    gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + 0.08);
    
    oscillator.start();
    oscillator.stop(this.audioContext.currentTime + 0.08);
  }

  // Piece drop/merge sound (thud)
  playDrop() {
    if (!this.enabled) return;
    
    const oscillator = this.createOscillator(150, 'square');
    const gain = this.createGain(0.1);
    
    if (!oscillator || !gain) return;
    
    oscillator.connect(gain);
    gain.connect(this.audioContext.destination);
    
    oscillator.frequency.exponentialRampToValueAtTime(80, this.audioContext.currentTime + 0.1);
    gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + 0.05);
    
    oscillator.start();
    oscillator.stop(this.audioContext.currentTime + 0.15);
  }

  // Line clear sound (rising tone)
  playLineClear(numLines = 1) {
    if (!this.enabled) return;
    
    const baseFreq = 400;
    const duration = 0.3 + (numLines * 0.1);
    
    for (let i = 0; i < numLines; i++) {
      setTimeout(() => {
        const oscillator = this.createOscillator(baseFreq + (i * 100), 'sine');
        const gain = this.createGain(0.15);
        
        if (!oscillator || !gain) return;
        
        oscillator.connect(gain);
        gain.connect(this.audioContext.destination);
        
        oscillator.frequency.exponentialRampToValueAtTime(
          baseFreq + (i * 100) + 200, 
          this.audioContext.currentTime + 0.2
        );
        gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + 0.25);
        
        oscillator.start();
        oscillator.stop(this.audioContext.currentTime + 0.25);
      }, i * 50);
    }
  }

  // Game over sound (descending tones)
  playGameOver() {
    if (!this.enabled) return;
    
    const frequencies = [440, 370, 311, 262];
    
    frequencies.forEach((freq, i) => {
      setTimeout(() => {
        const oscillator = this.createOscillator(freq, 'sawtooth');
        const gain = this.createGain(0.2);
        
        if (!oscillator || !gain) return;
        
        oscillator.connect(gain);
        gain.connect(this.audioContext.destination);
        
        gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + 0.4);
        
        oscillator.start();
        oscillator.stop(this.audioContext.currentTime + 0.4);
      }, i * 200);
    });
  }

  // Level up / achievement sound (celebratory)
  playLevelUp() {
    if (!this.enabled) return;
    
    const oscillator1 = this.createOscillator(523, 'sine'); // C5
    const oscillator2 = this.createOscillator(659, 'sine'); // E5
    const oscillator3 = this.createOscillator(784, 'sine'); // G5
    
    const gain = this.createGain(0.15);
    
    if (!oscillator1 || !oscillator2 || !oscillator3 || !gain) return;
    
    oscillator1.connect(gain);
    oscillator2.connect(gain);
    oscillator3.connect(gain);
    gain.connect(this.audioContext.destination);
    
    gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + 0.5);
    
    oscillator1.start();
    oscillator2.start(this.audioContext.currentTime + 0.1);
    oscillator3.start(this.audioContext.currentTime + 0.2);
    
    oscillator1.stop(this.audioContext.currentTime + 0.5);
    oscillator2.stop(this.audioContext.currentTime + 0.5);
    oscillator3.stop(this.audioContext.currentTime + 0.5);
  }

  // Start SID background music (Sanxion)
  startBackgroundMusic() {
    if (!this.enabled) {
      console.warn('Audio disabled');
      return;
    }

    // If user hasn't interacted yet, queue the music to start after interaction
    if (!this.userInteracted) {
      console.log('Queueing SID music to start after user interaction');
      const startMusicAfterInteraction = () => {
        // Small delay to ensure jsSID is fully initialized
        setTimeout(() => {
          this.startBackgroundMusic();
        }, 100);
      };
      
      ['click', 'keydown', 'touchstart'].forEach(event => {
        document.addEventListener(event, startMusicAfterInteraction, { once: true });
      });
      return;
    }

    if (!this.sidPlayer || !this.sidLoaded) {
      console.warn('SID player not ready');
      return;
    }
    
    try {
      // Make sure audio context is running
      if (this.audioContext && this.audioContext.state === 'suspended') {
        this.audioContext.resume();
      }
      
      // Set lower volume for background music
      this.sidPlayer.setvolume(0.05); // Reduce from default 1.0 to 0.3
      
      // Start playing using the jsSID API
      this.sidPlayer.start(0); // Start with subtune 0
      
      console.log('SID music started');
    } catch (e) {
      console.warn('Error starting SID music:', e);
    }
  }

  // Stop SID background music
  stopBackgroundMusic() {
    if (this.sidPlayer) {
      try {
        this.sidPlayer.pause();
        console.log('SID music stopped');
      } catch (e) {
        console.warn('Error stopping SID music:', e);
      }
    }
  }

  // Toggle audio on/off
  toggle() {
    this.enabled = !this.enabled;
    if (!this.enabled) {
      this.stopBackgroundMusic();
    }
    return this.enabled;
  }

  // Set master volume (0-1)
  setVolume(volume) {
    this.masterVolume = Math.max(0, Math.min(1, volume));
  }
}

// Export for use in main app
export default TetrisAudio;