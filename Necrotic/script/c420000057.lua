--Necroform
function c420000057.initial_effect(c)
    --first ss
    c:EnableReviveLimit()
    --materials
    Fusion.AddProcMix(c, true, true, 28297833, c420000057.ffilter)
    Fusion.AddContactProc(c, c420000057.contactfil, c420000057.contactop, c420000057.splimit)

    --change code
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(28297833)
    c:RegisterEffect(e1)

    --banish summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(420000057, 0))
    e1:SetCode(EVENT_REMOVE)
    e1:SetTarget(c420000057.target)
    e1:SetOperation(c420000057.operation)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, 420000057 + 100)
    c:RegisterEffect(e1)
end
function c420000057.ffilter(c)
    return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c420000057.splimit(e, se, sp, st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c420000057.matfil(c, tp)
    return c:IsAbleToRemoveAsCost()
end
function c420000057.contactfil(tp)
    return Duel.GetMatchingGroup(c420000057.matfil, tp, LOCATION_MZONE + LOCATION_HAND, 0, nil, tp)
end
function c420000057.contactop(g)
    Duel.Remove(g, POS_FACEUP, REASON_COST + REASON_MATERIAL)
end

function c420000057.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end
function c420000057.operation(e, tp, eg, ep, ev, re, r, rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(), 0, tp, tp, false, false, POS_FACEUP)
    end
end
