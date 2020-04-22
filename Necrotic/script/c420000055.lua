--Necroflesh
function c420000055.initial_effect(c)
    --first ss
    c:EnableReviveLimit()
    --materials
    Fusion.AddProcMix(c, true, true, 28297833, c420000055.ffilter)
    Fusion.AddContactProc(c, c420000055.contactfil, c420000055.contactop, c420000055.splimit, aux.TRUE, 1)

    --change code
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(28297833)
    c:RegisterEffect(e1)

    --banish monster
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(420000055, 1))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1, 420000055 + 100)
    e3:SetTarget(c420000055.rmtg)
    e3:SetOperation(c420000055.rmop)
    c:RegisterEffect(e3)
end
function c420000055.ffilter(c)
    return c:IsType(TYPE_FUSION) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c420000055.splimit(e, se, sp, st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c420000055.matfil(c, tp)
    return c:IsAbleToRemoveAsCost()
end
function c420000055.contactfil(tp)
    return Duel.GetMatchingGroup(c420000055.matfil, tp, LOCATION_GRAVE, 0, nil, tp)
end
function c420000055.contactop(g)
    Duel.Remove(g, POS_FACEUP, REASON_COST + REASON_MATERIAL)
end

function c420000055.rmtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove()
    end
    if chk == 0 then
        return Duel.IsExistingTarget(Card.IsAbleToRemove, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end
function c420000055.rmop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc, 0, REASON_EFFECT + REASON_TEMPORARY) ~= 0 then
        tc:RegisterFlagEffect(420000055, RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END, 0, 1)
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE + PHASE_END)
        e1:SetReset(RESET_PHASE + PHASE_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetCondition(c420000055.retcon)
        e1:SetOperation(c420000055.retop)
        Duel.RegisterEffect(e1, tp)
    end
end
function c420000055.retcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetLabelObject():GetFlagEffect(420000055) ~= 0
end
function c420000055.retop(e, tp, eg, ep, ev, re, r, rp)
    Duel.ReturnToField(e:GetLabelObject())
end
