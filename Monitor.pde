class Monitor {
  // View class showing a bar-graph of each channel's 
  // One instance per EEG channel.

  int x, y, w, h, currentValue, targetValue, backgroundColor;
  Channel sourceChannel;
  CheckBox showGraph;	
  Textlabel label;
  Toggle toggle;

  Monitor(Channel _sourceChannel, int _x, int _y, int _w, int _h) {
    sourceChannel = _sourceChannel;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    currentValue = 0;
    backgroundColor = color(255);

    // Create GUI
    showGraph = controlP5.addCheckBox("showGraph" + sourceChannel.name, x + 16, y + 34);
    showGraph.addItem("GRAPH" + sourceChannel.name, 0);
    showGraph.activate(0);
    showGraph.setColorForeground(sourceChannel.drawColor);
    showGraph.setColorActive(color(0));
    showGraph.setColorBackground(color(180));

    toggle = showGraph.getItem(0);
    toggle.setLabel("GRAPH"); 

    label = new Textlabel(controlP5, sourceChannel.name, x + 16, y + 16);
    label.setFont(ControlP5.grixel);
    label.setColorValue(0);
  }

  void update() {
    sourceChannel.graphMe = (showGraph.getItem(0).value() == 0);
  }

  void draw() {
    
  // Zombie  
  if (keyPressed == true) {
    trip = 1;
    println("Locked and loaded. Try to think human thoughts.");
    // servo_serial.write("\0");
  }
    
    
    pushMatrix();
    translate(x, y);

    // Background
    noStroke();
    fill(backgroundColor);
    rect(0, 0, w, h);

    // Border line
    strokeWeight(1);
    stroke(220);
    line(w - 1, 0, w - 1, h);

    // Bar graph
    if (sourceChannel.points.size() > 0) {
      Point targetPoint = (Point)sourceChannel.points.get(sourceChannel.points.size() - 1);
      targetValue = round(map(targetPoint.value, sourceChannel.minValue, sourceChannel.maxValue, 0, h));

      if ((scaleMode == "Global") && sourceChannel.allowGlobal) {					
        targetValue = (int)map(targetPoint.value, 0, globalMax, 0, h);
      }	

      // Calculate the new position on the way to the target with easing
      currentValue = currentValue + round(((float)(targetValue - currentValue) * .08));

      // Bar
      noStroke();
      fill(sourceChannel.drawColor);
      rect(0, h - currentValue, w, h);
    }

    // Draw the checkbox matte
    noStroke();
    fill(255, 150);		
    rect(10, 10, w - 20, 40);

    popMatrix();
    label.draw();
  }
}

