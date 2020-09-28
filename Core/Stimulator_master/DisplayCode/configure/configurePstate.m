function configurePstate(modID)

switch modID
    case 'PG'
        configurePstate_perGrater
    case 'FG'
        configurePstate_flashGrater
    case 'RD'
        configurePstate_Rain
    case 'FN'
        configurePstate_Noise
    case 'MP'
        configurePstate_Mapper
    case 'CM'
        configurePstate_cohMotion
        
end     