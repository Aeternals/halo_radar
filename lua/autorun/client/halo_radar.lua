--Halo 5 Radar by Aeternal

local radar_img = Material("VGUI/radar.png")
	
--Wiki's Draw Circle

function draw.Circle( x, y, radius, seg )

	local cir = {}
	
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	
	for i = 0, seg do
	
		local a = math.rad( ( i / seg ) * -360 )
		
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		
	end
	
	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
	
end

local clred = Color( 255, 0, 0, 255 )
local units_inch	= 4 / 3
local units_feet	= units_inch * 12

local radar = {

    config = {
	
        draw_circle = false; --Draw outside circle
        draw_dot    = true; --Draw dots on Radar
        draw_name   = false; --Draw NPC's name on the Radar
        name_color  = color_white; --Color of the NPC's Name
		
    };
	
    hud = {
	
        x = 41;
        y = ScrH() - 181;
        w = 175;
        r = 150 / 2;
        b = 5;

        bg_color = Color( 250, 250, 250, 255 );
        draw_range_circle = false;
        range_circle_color = color_white;
		
    };
	
}

hook.Add("HUDPaint", "halo_radar", function()

	local ply = LocalPlayer()
	local ypos = 300

	if !ply:Alive() then --Check if Player is alive if not end
	
		return
		
	end	
		
		local x, y = radar.hud.r + radar.hud.x, radar.hud.r + radar.hud.y;
		local rot = -ply:GetAngles().y-90
		
		
		surface.SetFont("Default")
		surface.SetDrawColor(255,255,255,255)
		surface.SetTextPos(20, ScrH() - 40)
		surface.DrawText("30M")
		
		surface.SetMaterial( radar_img );
		surface.SetDrawColor( radar.hud.bg_color );
		//surface.DrawTexturedRect( 39 ,ScrH() - 182, radar.hud.w, radar.hud.w);
		surface.DrawTexturedRectRotated( 114 ,ScrH() - 106.5, radar.hud.w, radar.hud.w, rot);
	
		if ( radar.hud.draw_range_circle ) then
		
			surface.DrawCircle( x, y, radar.hud.r, radar.hud.range_circle_color || color_white );
			draw.RoundedBox( 0, x, y, 2, 2, clred );
			
		end
	
		surface.SetFont( "Default" );
		surface.SetTextColor( radar.config.name_color || color_white );
	
		local pos = ply:GetPos( );
		
		pos.z = 0;
	
		local ang = ply:EyeAngles( );
		
		ang.p = 0; ang.y = ang.y; ang.r = 0;
		
		for k, v in pairs( ents.GetAll() ) do
			
			if v:IsNPC() or v:IsPlayer() then
				
				if  v == LocalPlayer() then
				
					continue 
				
				end
			
			local tpos = WorldToLocal( pos, ang, v:GetPos( ), ang ); tpos.z = 0
			local len = vector_origin:Distance( tpos ) / units_feet
			
			if ( len > 84 ) then continue end
			
			local color = clred 
			local rad_x = ( tpos.x - 32 ) / units_feet
			local rad_y = ( tpos.y - 32 ) / units_feet
	
			rad_x, rad_y = rad_y, rad_x;
	
			/* --This is a debugging tool. It will draw a circle on each dot to make sure the radar bounds are correct

        if ( radar.config.draw_circle ) then
		
            surface.DrawCircle( x, y, len, color )
			
        end
*/

        if ( radar.config.draw_dot ) then
		
            draw.RoundedBox( 4, x + rad_x - ( radar.hud.b / 2 ), y + rad_y - ( radar.hud.b / 2 ), 5, 5, clred )
			
        end

/* --This is also a debugging tool. It will draw the names of each dot.
        if ( radar.config.draw_name ) then
		
            surface.SetTextPos( x + rad_x, y + rad_y )
			surface.SetDrawColor(clred)
            surface.DrawText( v:Nick( ) )
			
        end
*/
		
    end
	
end

		cam.Start2D()
			
			if ply:GetVelocity():Length() <= 0 then    --Draw players dot if moving
			
				return false 
				
			else    
			
				surface.SetDrawColor( 255,255, 0, 200 )
				draw.NoTexture()
				draw.Circle( 114.5, ScrH() - 107.5, 6, 100 )
				
			end
			
		cam.End2D()

end)

hook.Add( "HUDShouldDraw","HideDefaultHUD", function( def_hud )

	shoulddrawtable = 	
	
{

	["CHudAmmo"] = true,
	["CHudHealth"] = false,
	["CHudBattery"] = false,			
	["CHudSecondaryAmmo"] = true,
	
}

	return shoulddrawtable[ def_hud ]
	
end)