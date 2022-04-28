color STDRESOURCECOLOR1 = #00FF0E;
color STDRESOURCECOLOR2 = #FF0000;


class Resource{
  
  int type;                                                              //Type index
  float x, y;                                                            //Position
  int res;                                                               //Amount of resource held
  float size;
  color cl;                                                    //Color
  
  //Constructors
  
  Resource(int argType, color argCl){
    Random r = new Random();                                             //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                         //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                         //Random position
    
    type = argType;                                                            //Type of resource
    
    cl = argCl;                                                            //Color of resource
    
    res = 200;                                                            //Initial resource stored by default
    size = 20 + res/10;
    
  }
  
  //Getters
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getSize(){
    return size;
  }
  
  int getType(){
    return type;
  }
  
  //Setters
  
  //Methods
  
  boolean lowerRes(){                                                    //Lower stored resource amount
    res--;
    size = 20 + res/10;
    return (res == 0);
    
  }
  
  //Renderers
    
  void render(){                                                         //Renders resource
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}
