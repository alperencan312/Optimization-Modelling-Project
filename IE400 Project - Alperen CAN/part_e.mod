/*********************************************
 * OPL 20.1.0.0 Model
 * Author: alperen
 * Creation Date: 1 May 2022 at 13:47:00
 *********************************************/

//Ranges

range product=1..45;
range market=1..5;
range need=1..4;
range beverage=1..18;
range carbodydrate=19..29;
range cheese=30..39;
range breakfast=40..45;

//Parameters

float C[i in product]=...;//unit price of product i
float S[i in product]=...;//unit satisfaction of product i
float A[i in product]=...;//unit amount of product i
float T=...;//max travel limit
float d[k in market][l in market]=...;//distance between markets
float D[n in need]=...;
float B=...;//budget
int M[i in product][k in market]=...;//binary 1 if product i belongs market k
int bigM=100000;
int Td=...;// Time limit
int time[k in market]=...;//Time spent in each market
int V=...;//Speed

//Decision Variables

dvar int+ P[i in product];//# of packets bought
dvar boolean X[k in market][l in market];//1 if market l is visited right after market k
dvar boolean Z1;
dvar boolean loc[k in market];
dvar boolean Z2;

//Obj. Function

maximize sum(i in product)(S[i]*P[i])+B-sum(i in product)(P[i]*C[i]);

//Constraints

subject to{
  
    
   	constraint_1:
   
   	sum(k in market,l in market)(X[k][l]*d[k][l])<=T;//travel limit should be satisfied
   
    
    constraint_2:
    
    sum(i in product)(C[i]*P[i])<= B;//Budget limit
    
    
    constraint_3:
    
    sum(i in beverage)(P[i]*A[i])>=D[1];//Demand for beverage
    sum(i in carbodydrate)(P[i]*A[i])>=D[2];//Demand for carbodydrate
    sum(i in cheese)(P[i]*A[i])>=D[3];//Demand for cheese
    sum(i in breakfast)(P[i]*A[i])>=D[4];//Demand for breakfast
    
    
    constraint_4:
    
    sum(l in market:l!=5)(X[5][l])==1;//Start from House
   	sum(l in market:l!=5)(X[l][5])==1;//End in House
   	forall(k in market){
   	  sum(l in market)(X[k][l])<=1;   //At most 1 travel at a time
   	}
   	
   	
   	constraint_5:
   	
   	forall(i in product,k in market:k!=5){
   	  P[i]*M[i][k]<=bigM*Z1;
   	  sum(l in market:l!=k)(X[l][k])-1>=bigM*(1-Z1); //Market should be visited if we bought a product from that market.
   	}
   	
   	
   	constraint_6:
   	
   	forall(k in market){
   	  sum(l in market)(X[l][k])<=bigM*Z2; // Makes decvar loc[k] 1 if market k is visited.
   	  1-loc[k]<=bigM*(1-Z2);
  	}   	  
  	
  	
  	constraint_7: //Time limit
  	
  		sum(k in market,l in market:k!=l)(loc[k]*time[k]+X[k][l]*d[k][l]/V)<=Td;
 	  	
}