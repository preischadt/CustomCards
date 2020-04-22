--Dusker
function c420000056.initial_effect(c)
    --first ss
    c:EnableReviveLimit()
    --materials
    Fusion.AddProcMix(c, true, true, 28297833, c420000056.ffilter)
    Fusion.AddContactProc(c, c420000056.contactfil, c420000056.contactop, c420000056.splimit)

    --destroy
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(420000056, 2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetHintTiming(0, TIMINGS_CHECK_MONSTER_E)
    e4:SetCost(c420000056.descost)
    e4:SetTarget(c420000056.destg)
    e4:SetOperation(c420000056.desop)
    c:RegisterEffect(e4)
end
function c420000056.ffilter(c)
    return c:IsType(TYPE_XYZ) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c420000056.splimit(e, se, sp, st)
    return false
end

function c420000056.matfil(c, tp)
    return c:IsAbleToRemoveAsCost()
end
function c420000056.contactfil(tp)
    return Duel.GetMatchingGroup(c420000056.matfil, tp, LOCATION_MZONE, 0, nil, tp)
end
function c420000056.contactop(g)
    Duel.Remove(g, POS_FACEUP, REASON_COST + REASON_MATERIAL)
end

local TYPE_FULL = TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK
function c420000056.costfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FULL) and c:IsAbleToRemoveAsCost()
end
function c420000056.descost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(c420000056.costfilter, tp, LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, c420000056.costfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.Remove(g, POS_FACEUP, REASON_COST)
end
function c420000056.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsOnField() and chkc:IsFaceup()
    end
    if chk == 0 then
        return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
    end
    Duel.Hint(HINT_OPSELECTED, 1 - tp, e:GetDescription())
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end
function c420000056.desop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end
