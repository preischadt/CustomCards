--Necrofake
function c420000052.initial_effect(c)
    --first ss
    c:EnableReviveLimit()
    --materials
    Fusion.AddProcMix(c, true, true, 28297833, c420000052.ffilter)
    Fusion.AddContactProc(c, c420000052.contactfil, c420000052.contactop, c420000052.splimit, aux.TRUE, 1)

    --change code
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(28297833)
    c:RegisterEffect(e1)

    --prepare reset
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(20292186, 1))
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c420000052.dcon)
    e3:SetOperation(c420000052.dop)
    c:RegisterEffect(e3)
end
function c420000052.ffilter(c)
    return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c420000052.splimit(e, se, sp, st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c420000052.matfil(c, tp)
    return c:IsAbleToRemoveAsCost()
end
function c420000052.contactfil(tp)
    return Duel.GetMatchingGroup(c420000052.matfil, tp, LOCATION_GRAVE, 0, nil, tp)
end
function c420000052.contactop(g)
    Duel.Remove(g, POS_FACEUP, REASON_COST + REASON_MATERIAL)
end

function c420000052.retcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end
function c420000052.retop(e, tp, eg, ep, ev, re, r, rp)
    local tc = e:GetLabelObject()
    local g = Duel.GetFieldGroup(tp, LOCATION_REMOVED, LOCATION_REMOVED)
    Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
end

function c420000052.dcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetSummonType() == SUMMON_TYPE_SPECIAL + 1
end
function c420000052.dop(e, tp, eg, ep, ev, re, r, rp)
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e1:SetCountLimit(1, 420000052 + 100)
    e1:SetReset(RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN)
    e1:SetCondition(c420000052.retcon)
    e1:SetOperation(c420000052.retop)
    e1:SetLabelObject(e:GetHandler())
    Duel.RegisterEffect(e1, tp)
end
