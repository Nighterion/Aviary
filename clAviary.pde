color WALLCOLOR = #023600;                                                            //Color of aviary boundaries
int WALLTHICKNESS = 20;                                                               //Thickness of aviary boundaries (!!!KEEP MORE THAN MAXIMUM AGENT SPEED!!!)




class Aviary {
  
  int resourceTypeAmount;                                                                      //Amount of resource types
  
  int baseAmount;                                                                       //Amount of bases
  int resourceAmount;                                                                        //Amount of resources TODO: MAKE IT AN ARRAY SIZED resourceTypeAmount TO KEEP AMOUNTS OF RESOURCES OF EACH TYPE
  
  int agentCounter;                                                                       //Agent counter
  
  color baseCl = #3483FF;                                                             //Base color (single)
  ArrayList<Integer> resCl;
  
  ArrayList<Base> bases;                                                              //
  ArrayList<Resource> resourcesList;                                                         //
  ArrayList<Agent> agents;                                                          //ArrayLists TODO: MAKE IT MULTIPLE RESOURCE TYPE COMPATIBLE
  

  //Constructors
  
  Aviary(int argBaseAmnt,                                                             //Amount of bases
         int argResAmnt,                                                              //Amount of resources
         int argInitAgentAmnt                                                         //Initial amount of agents
         ){
    
    resourceTypeAmount = 2;                                                                    //Double resource type by default
    
    baseAmount = argBaseAmnt;                                                           //
    resourceAmount = argResAmnt;                                                             //
    agentCounter = argInitAgentAmnt;                                                      //Set amounts
    
    bases = new ArrayList<Base>(argBaseAmnt);                                         //
    resourcesList = new ArrayList<Resource>(argResAmnt);                                     //
    agents = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    
    resCl = new ArrayList<Integer>(resourceTypeAmount);

    //resCl[0] = resCl1;
    //resCl[1] = resCl2;
    
    resCl.add(#00FF0E);
    resCl.add(#FF0000);
    
    
    for(int i = 0; i < baseAmount; i++){                                                //
      bases.add(new Base());                                                          //
    }                                                                                 //Add bases
    
    Random r = new Random();
    
    int tmpTypeCounter1 = 0;
    int tmpTypeCounter2 = 0;
    
    for(int i = 0; i < resourceAmount; i++){    
      if(i == 3 && tmpTypeCounter1 == 0){
        resourcesList.add(new Resource(0,resCl.get(0)));
        resourcesList.add(new Resource(0,resCl.get(0)));
        break;
      }
      
      if(i == 3 && tmpTypeCounter2 == 0){
        resourcesList.add(new Resource(1,resCl.get(1)));
        resourcesList.add(new Resource(1,resCl.get(1)));
        break;
      }
      int tmpNum = r.nextInt(2);
      if(tmpNum == 0)
        tmpTypeCounter1++;
      else 
        tmpTypeCounter2++;
      resourcesList.add(new Resource(tmpNum,resCl.get(tmpNum)));     //
    }                                                                                 //Add resources
    
    for(int i = 0; i < agentCounter; i++){                                                //
      agents.add(new Agent());                                                      //
    }                                                                                 //Add agents 
  }
  
  //Getters
  
  //Setters
  
  //Methods
  
  void scream(Agent agent){                                                           //Performs scream of agent
  
    agents.forEach((ag) -> {                                                       //For each agent
      
      float distance = ag.getDistTo(agent.getX(), agent.getY());                     //Calculate distance to screamer
      int scrHearDist = ag.getScrHearDist();                                         //Get hearing distance
      
      if(ag.ifHearFrom(distance)){                                                   //If agent can hear
        int bsDist = agent.getBaseDist();                                             //Get screamers supposed base distance
        
        if(bsDist + scrHearDist < ag.getBaseDist()){                                 //If screamer is supposedly closer to base, !!!considering hearing distance!!!
          ag.setBaseDist(bsDist + scrHearDist);                                      //Set new supposed base distance for hearer
          ag.setBaseDir(ag.directionToFace(agent.getX(), agent.getY(), distance));  //Set new supposed base direction for hearer !!!as a direction to the screamer, not screamers supposed direction to the base!!!
          ag.peakScreamCounter();
          if(ag.getFlag() == 0) ag.updateDir();                                     //If hearer is currently seeking base                                                          //Update his current direction
        }
        
        for(int i = 0; i < resourceTypeAmount; i++){           
          int resDist = agent.getResDist(i);                            
          if(resDist + scrHearDist < ag.getResDist(i)){            
            ag.setResDist(i, resDist + ag.getScrHearDist());
            ag.setResDir(i, ag.directionToFace(agent.getX(), agent.getY(), distance));
            ag.peakScreamCounter();
            if(ag.getFlag() == i + 1)  ag.updateDir();                                                        //Do the same for all resource types
          }
        } 
      }
    });
  }
  
  void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.ifReadyToScream())
        scream(agent);
    });
  }
  
  void run(int defX, int defY){                                                       //Main method
    render(defX, defY);                                                               //Render boundaries, bases and resources
    tick();                                                                           //Perform animation tick
    renderAgent();                                                                    //Render agants
  }
    
  
  void tick(){                                                                        //Performes animation tick
    agents.forEach((agent) -> {                                                       //For each agent
      color curCl = agent.step();                                                       //Perform step, get color from new location
      if(curCl == baseCl){          //If found base
        agent.setBaseDist(0);                                                           //!!!Set supposed distance to base to 0!!!
                                                                 //!!!Update direction accordingly to new action flag!!!                                                       
        agent.peakScreamCounter();                                                    //Get ready to scream
        agent.dropResources();
        if(agent.getResType() == 0){
          bases.get(0).incR1();
        }
        if(agent.getResType() == 1){
          bases.get(0).incR2();
        }
        if(bases.get(0).getAlpha() <= 1){
          agent.setFlag(1);                                                               //Set action flag to seek resource 1
          agent.updateDir();     
        }
        else{
          agent.setFlag(2);                                                               //Set action flag to seek resource 2
          agent.updateDir();     
        }

        
      }
      for(int i = 0; i < resourceTypeAmount; i++)
      {
        if(curCl == resCl.get(i) ){                                                             //If found resource
        int at = 0;
        int idx = -1;
          for (Resource res: resourcesList){
            if(agent.getDistTo(res.getX(), res.getY()) <= res.getSize() && res.getType() == i){
              idx = at;
            }
            at++;            
          }
          agent.setFlag(0);                                                               //Set action flag to seek base
          agent.setResDist(i, 0);                                                         //!!!Set supposed distance to resource to 0!!!
          agent.updateDir();                                                              //!!!Update direction accordingly to new action flag!!!
          agent.peakScreamCounter();                                                    //Get ready to scream
          if(idx != -1){
            if (agent.getLoad() < agent.getMaxLoad()){
              agent.addRes(i);
              agent.setResType(i);
              if(resourcesList.get(idx).lowerRes()){
                resourcesList.remove(idx);
              
                 Random r = new Random();
                 int tmpNum = r.nextInt(2);
                 
                 int tmpTypeCounter1 = 0;
                 int tmpTypeCounter2 = 0;
                 
                 for(int k = 0; k < resourceAmount - 1; k++) {
                   if(resourcesList.get(k).getType() == 0)
                     tmpTypeCounter1++;
                   else
                     tmpTypeCounter2++;
                 }
                 if (tmpTypeCounter1 <= 1)
                   resourcesList.add(new Resource(0, resCl.get(0)));
                 else if (tmpTypeCounter2 <= 1)
                   resourcesList.add(new Resource(1, resCl.get(1)));
                 else
                   resourcesList.add(new Resource(tmpNum, resCl.get(tmpNum)));
              }
            }
          }
        }
      }
    });    
    screams();                                                                        //Perform screams
  }
  
  void moveBase(int baseId, float argX, float argY){
    bases.get(baseId).setPos(argX, argY);
  }
  
  //Renderers
  
  void renderBounds(int defX, int defY){                                              //Renders boundaries of aviary

  strokeWeight(WALLTHICKNESS);  stroke(WALLCOLOR);
  line(WALLTHICKNESS / 2, WALLTHICKNESS / 2, WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2);
  line(WALLTHICKNESS / 2, WALLTHICKNESS / 2, defX - WALLTHICKNESS / 2, WALLTHICKNESS / 2);
  line(defX - WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2, defX - WALLTHICKNESS / 2, WALLTHICKNESS / 2);
  line(defX - WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2, WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2);
  
}

  void renderBase(){                                                                  //Renders bases
    bases.forEach((base) -> base.render());
  }
  
  void renderRes(){                                                                   //Renders resources
    resourcesList.forEach((res) -> res.render());
  }
  
  void renderAgent(){                                                                 //Renders agents
    agents.forEach((agent) -> agent.render());
  }
  
  void render(int defX, int defY){                                                    //Renders aviary
    background(0);
    renderBounds(defX, defY);
    renderBase();
    renderRes();
    fill(255);  // инструкция
    text("ЛКМ - перемещение базы, R - перезапуск, P - пауза", defX / 2 - 100, defY - 6);
  }
  
  
}
