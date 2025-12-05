class Pet {
  double hunger; // 0 to 100 (100 is full)
  double energy; // 0 to 100 (100 is fully rested)
  double happiness; // 0 to 100 (100 is happy)
  double hygiene; // 0 to 100 (100 is clean)
  bool isSleeping;

  Pet({
    this.hunger = 80,
    this.energy = 80,
    this.happiness = 80,
    this.hygiene = 80,
    this.isSleeping = false,
  });

  void decay() {
    if (isSleeping) {
      energy = (energy + 5).clamp(0, 100);
      hunger = (hunger - 0.5).clamp(0, 100); // Gets hungry slower while sleeping
      hygiene = (hygiene - 0.5).clamp(0, 100);
    } else {
      hunger = (hunger - 2).clamp(0, 100);
      energy = (energy - 1.5).clamp(0, 100);
      happiness = (happiness - 1).clamp(0, 100);
      hygiene = (hygiene - 1).clamp(0, 100);
    }
  }

  void feed() {
    hunger = (hunger + 20).clamp(0, 100);
    energy = (energy + 5).clamp(0, 100);
    if (isSleeping) wakeUp();
  }

  void play() {
    if (energy > 10) {
      happiness = (happiness + 20).clamp(0, 100);
      energy = (energy - 15).clamp(0, 100);
      hunger = (hunger - 5).clamp(0, 100);
      if (isSleeping) wakeUp();
    }
  }

  void clean() {
    hygiene = 100;
    happiness = (happiness + 10).clamp(0, 100);
    if (isSleeping) wakeUp();
  }

  void sleep() {
    isSleeping = true;
  }

  void wakeUp() {
    isSleeping = false;
  }

  // Getters for status
  bool get isHungry => hunger < 30;
  bool get isTired => energy < 30;
  bool get isSad => happiness < 30;
  bool get isDirty => hygiene < 30;
  bool get isDead => hunger == 0 && energy == 0; // Extreme state
}
