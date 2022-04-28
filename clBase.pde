color STDBASECOLOR = #3483FF;


class Base{
  
  float x, y;                                                                        //Position
  int resourceTypeAmount;                                                                     //Amount of resource types
  int[] res;                                                                         //Array for stored resources by type
  color cl = #3483FF;                                                                //Base color
  float size = 40;                                                                   //Base size px
  float alpha;
  int R1;
  int R2;
  
  //Constructors
  
  Base(){
    Random r = new Random();                                                         //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                                     //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                                     //Random position
    
    resourceTypeAmount = 2;                                                                   //Single resource type by default
    res = new int[resourceTypeAmount];                                                        //Make stored resources by type array
    
    alpha = 1;
    R1 = 1;
    R2 = 1;
    
    for(int i = 0; i < resourceTypeAmount; i++)
      res[i] = 0;
  }
  
  //Getters
  
  float getAlpha(){
    return alpha;
  }
  
  //Setters
  
  void setPos(float argX, float argY){
    x = argX;
    y = argY;
  }
  
  void incR1(){
    R1++;
    setAlpha();
  }
  
  void incR2(){
    R2++;
    setAlpha();
  }
  
  void setAlpha(){
    alpha = float(R1)/float(R2);
    println(alpha);
  }
  
  //Methods
  
  void addRes(int argResTp, int argResAmnt){                                         //Adds resource to storage
    res[argResTp] += argResAmnt;
  }
  
  //Renderers
  
  void render()                                                                      //Renders base
  {
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}
