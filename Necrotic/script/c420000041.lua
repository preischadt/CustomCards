--Lotus
function c420000041.initial_effect(c)
    --first ss
    c:EnableReviveLimit()
    --materials
    Fusion.AddProcMix(c, true, true, 28297833, c420000041.ffilter)
    Fusion.AddContactProc(c, c420000041.contactfil, c420000041.contactop, c420000041.splimit)

    --remove
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetDescription(aux.Stringid(420000041, 0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1, 420000041)
    e1:SetTarget(c420000041.target)
    e1:SetOperation(c420000041.operation)
    c:RegisterEffect(e1)
end
function c420000041.ffilter(c)
    return c:IsType(TYPE_SYNCHRO) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end
function c420000041.splimit(e, se, sp, st)
    return false
end

function c420000041.matfil(c, tp)
    return c:IsAbleToRemoveAsCost()
end
function c420000041.contactfil(tp)
    return Duel.GetMatchingGroup(c420000041.matfil, tp, LOCATION_MZONE, 0, nil, tp)
end
function c420000041.contactop(g)
    Duel.Remove(g, POS_FACEUP, REASON_COST + REASON_MATERIAL)
end

function c420000041.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chkc then
        return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove()
    end
    if chk == 0 then
        return e:GetHandler():IsAbleToRemove() and
            Duel.IsExistingTarget(Card.IsAbleToRemove, tp, LOCATION_MZONE, 0, 1, e:GetHandler())
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, LOCATION_MZONE, 0, 1, 1, e:GetHandler())
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end
function c420000041.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    local g = Group.FromCards(c, tc)
    g:KeepAlive()
    if
        c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsControler(tp) and
            Duel.Remove(g, nil, REASON_EFFECT + REASON_TEMPORARY) ~= 0
     then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_END)
        e1:SetLabelObject(g)
        e1:SetCountLimit(1)
        e1:SetOperation(c420000041.retop)
        Duel.RegisterEffect(e1, tp)
    end
end
function c420000041.retop(e, tp, eg, ep, ev, re, r, rp)
    e:Reset()
    local g = e:GetLabelObject()
    local tc = g:GetFirst()
    while tc do
        if tc:IsForbidden() then
            Duel.SendtoGrave(tc, REASON_RULE)
        else
            Duel.ReturnToField(tc)
        end
        tc = g:GetNext()
    end
end
