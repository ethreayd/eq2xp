function main(string ToonName)
{
    do
    {
        while (${Zone.Name.Equal["LoginScene"]} || ${Zone.Name.Equal["Unknown"]})
        {
            wait 600
            if (${Zone.Name.Equal["LoginScene"]} || ${Zone.Name.Equal["Unknown"]})
            {
                echo Zone Name seems to be stuck at ${Zone.Name} - Restarting Ogre for ${ToonName} (${Me.Name})
                ogre -noredirect "${ToonName}"
            }
        }
    }
    while (1)
}
