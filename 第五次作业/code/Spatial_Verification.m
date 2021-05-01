function [ Wrong_Matched_Point ] = Spatial_Verification( record_Q_M , Spr)
FUNCSTART = 1; Wrong_Matched_Point = [] 
while (FUNCSTART)

  [SpN,SpM] = size(record_Q_M) ;  % i = 1,...,SpN
  Sp_Theta = [0:1:Spr-1].*(pi / (2*Spr));
  disp(SpN)
  ALLQ_x_i_k = zeros(SpN,length(Sp_Theta));
  ALLQ_y_i_k = zeros(SpN,length(Sp_Theta));

  ALLM_x_i_k = zeros(SpN,length(Sp_Theta));
  ALLM_y_i_k = zeros(SpN,length(Sp_Theta));

  for Spk=1:Spr
     ALLQ_x_i_k(:,Spk) = cos(Sp_Theta(Spk)).*(record_Q_M(:,1)) - sin(Sp_Theta(Spk)).*(record_Q_M(:,2));
     ALLQ_y_i_k(:,Spk) = sin(Sp_Theta(Spk)).*(record_Q_M(:,1)) + cos(Sp_Theta(Spk)).*(record_Q_M(:,2));
  end

  for Spk=1:Spr
     ALLM_x_i_k(:,Spk) = cos(Sp_Theta(Spk)).*(record_Q_M(:,3)) - sin(Sp_Theta(Spk)).*(record_Q_M(:,4));
     ALLM_y_i_k(:,Spk) = sin(Sp_Theta(Spk)).*(record_Q_M(:,3)) + cos(Sp_Theta(Spk)).*(record_Q_M(:,4));
  end

  for k = 1:Spr
      for i = 1:SpN
          for j = 1:SpN
              if ALLQ_x_i_k(i,k) < ALLQ_x_i_k(j,k)
                  GX_temp(i,j) = 0;
              else
                  GX_temp(i,j) = 1;
              end
            
              if ALLQ_y_i_k(i,k) < ALLQ_y_i_k(j,k)
                  GY_temp(i,j) = 0;
              else
                  GY_temp(i,j) = 1;
              end
          end
      end
      GXQ{k} = GX_temp;
      GYQ{k} = GY_temp;
  end

  for k = 1:Spr
     for i = 1:SpN
         for j = 1:SpN
              if ALLM_x_i_k(i,k) < ALLM_x_i_k(j,k)
                  GX_temp(i,j) = 0;
              else
                  GX_temp(i,j) = 1;
              end
            
              if ALLM_y_i_k(i,k) < ALLM_y_i_k(j,k)
                  GY_temp(i,j) = 0;
              else
                  GY_temp(i,j) = 1;
              end
         end
     end
      GXM{k} = GX_temp;
      GYM{k} = GY_temp;
  end

  for k = 1:Spr
      VX{k} = xor(GXQ{k},GXM{k});
      VY{k} = xor(GYQ{k},GYM{k});
  end

  SX = VX{1}; SY = VY{1};
  for k = 2:Spr
      SX = SX + VX{k};
      SY = SY + VY{k};
  end
  
  % Condition of Quit
  if  ((sum(sum(SX))==0) && (sum(sum(SY))==0))
      FUNCSTART = 0;
  else
      sum_row_SX = sum( SX , 2 );
      sum_row_SY = sum( SY , 2 );
      
      IDSX = find(sum_row_SX==max(sum_row_SX));
      IDSY = find(sum_row_SY==max(sum_row_SY));
      
      if (max(sum_row_SX) >= max(sum_row_SY) )
          Serch_ID = IDSX(1);
      else
          Serch_ID = IDSY(1);
      end
      
      Wrong_Matched_Point = [Wrong_Matched_Point;record_Q_M(Serch_ID,:)]; 
      record_Q_M(Serch_ID,:) = [];
  end

end

end

